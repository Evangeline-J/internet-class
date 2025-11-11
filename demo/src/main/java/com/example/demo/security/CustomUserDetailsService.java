package com.example.demo.security;

import com.example.demo.role.dto.Role;
import com.example.demo.role.mapper.RoleMapper;
import com.example.demo.user.entity.User;
import com.example.demo.user.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserMapper userMapper;

    // 1. 注入 RoleMapper 以便查询角色
    @Autowired
    private RoleMapper roleMapper;

    @Override
    public UserDetails loadUserByUsername(String usernameOrEmail) throws UsernameNotFoundException {
        // 允许使用用户名或邮箱登录
        User user = userMapper.findByUsername(usernameOrEmail);
        if (user == null) {
            user = userMapper.findByEmail(usernameOrEmail);
        }

        if (user == null) {
            throw new UsernameNotFoundException("未找到用户: " + usernameOrEmail);
        }

        // 2. 根据用户ID获取该用户的所有角色
        Set<Role> roles = roleMapper.findRolesByUserId(user.getId());

        // 3. 将角色集合转换为 Spring Security 需要的 GrantedAuthority 集合
        //    Spring Security 的标准做法是在角色代码前加上 "ROLE_" 前缀。
        Collection<? extends GrantedAuthority> authorities = roles.stream()
                .map(role -> new SimpleGrantedAuthority("ROLE_" + role.getCode()))
                .collect(Collectors.toSet());

        // 4. 创建 CustomUserDetails 对象，这次传入了真实的权限信息
        return new CustomUserDetails(
                user.getId(),
                user.getUsername(),
                user.getPasswordHash(),
                authorities // <-- 使用我们刚刚创建的、包含真实角色的权限列表
        );
    }
}