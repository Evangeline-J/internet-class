package com.example.demo.auth.service.impl;

import com.example.demo.auth.service.AdminService;
import com.example.demo.user.mapper.UserMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service // 标记为 Spring 的服务组件
public class AdminServiceImpl implements AdminService {

    private static final Logger logger = LoggerFactory.getLogger(AdminServiceImpl.class);

    // 注入 UserMapper 以便操作数据库
    private final UserMapper userMapper;

    @Autowired
    public AdminServiceImpl(UserMapper userMapper) {
        this.userMapper = userMapper;
    }

    @Override
    @Transactional // 建议为修改操作添加事务支持
    public void deleteUser(Long userId) {
        logger.info("ADMIN ACTION: Received request to delete user with ID: {}", userId);

        // 1. 安全检查：删除前先确认用户是否存在
        userMapper.findById(userId)
                .orElseThrow(() -> {
                    // 如果用户不存在，抛出异常，全局异常处理器会捕获并返回 404 Not Found
                    logger.warn("ADMIN ACTION FAILED: User with ID {} not found.", userId);
                    // 你可以创建一个自定义的 ResourceNotFoundException 异常
                    return new RuntimeException("User not found with ID: " + userId);
                });

        // 2. 执行删除操作
        int affectedRows = userMapper.deleteById(userId);

        if (affectedRows > 0) {
            logger.info("ADMIN ACTION SUCCESS: Successfully deleted user with ID: {}", userId);
        } else {
            // 这种情况理论上在上面的 findById 检查后不会发生，但作为双重保障
            logger.error("ADMIN ACTION FAILED: Deletion failed for user with ID {}. No rows affected.", userId);
            throw new RuntimeException("Deletion failed for user with ID: " + userId);
        }
    }
}