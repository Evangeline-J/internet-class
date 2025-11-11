package com.example.demo.user.entity;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class User {
    private Long id;
    private String username;
    private String email;
    private String phone;

    // 字段名从 password 修改为 passwordHash 以匹配数据库的 password_hash
    private String passwordHash;

    private String nickname;
    private String avatarUrl;
    private String bio;

    // 数据库中是 tinyint，在Java中通常用 Integer 或 Short 映射
    private Integer status;
    private Boolean emailVerified;
    private Boolean phoneVerified;

    private Integer loginAttempts;
    private LocalDateTime lockedUntil;
    private LocalDateTime lastLoginAt;
    private String lastLoginIp;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime deletedAt;
}
