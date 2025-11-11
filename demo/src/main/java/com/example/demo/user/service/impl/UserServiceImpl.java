package com.example.demo.user.service.impl;

import com.example.demo.role.mapper.RoleMapper;
import com.example.demo.role.mapper.UserRoleMapper;
import com.example.demo.role.dto.Role;
import com.example.demo.user.dto.RegisterRequest;
import com.example.demo.user.entity.User;
import com.example.demo.user.mapper.UserMapper;
import com.example.demo.user.service.UserService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private RoleMapper roleMapper;

    @Autowired
    private UserRoleMapper userRoleMapper;

    @Override
    @Transactional
    public User register(RegisterRequest registerRequest) {
        // 检查用户名是否已存在
        if (userMapper.findByUsername(registerRequest.getUsername()) != null) {
            throw new RuntimeException("用户名已存在");
        }

        // 检查邮箱是否已存在
        if (userMapper.findByEmail(registerRequest.getEmail()) != null) {
            throw new RuntimeException("邮箱已被注册");
        }

        // 检查两次密码是否一致
        if (!registerRequest.getPassword().equals(registerRequest.getConfirmPassword())) {
            throw new RuntimeException("两次输入的密码不一致");
        }

        User user = new User();
        // BeanUtils 仍然可以复制 username, email, phone, nickname 等同名字段
        BeanUtils.copyProperties(registerRequest, user);

        // 1. 使用 setPasswordHash 方法
        // 2. 将加密后的密码设置到 passwordHash 字段
        user.setPasswordHash(passwordEncoder.encode(registerRequest.getPassword()));
        userMapper.insert(user);
        // 2. 查找 "user" 角色的 ID
        Role userRole = roleMapper.findByCode("user");
        if (userRole == null) {
            // 在生产环境中，这应该是一个更具体的异常，并且应该被全局异常处理器捕获
            throw new RuntimeException("默认角色 'user' 未在数据库中找到，请联系管理员！");
        }

        // 3. 在 `user_roles` 表中插入关联记录
        //    使用刚刚从 user 对象中获取的 ID 和查到的角色 ID
        userRoleMapper.assignRoleToUser(user.getId(), userRole.getId());

        return user;
    }
}