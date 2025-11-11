package com.example.demo.security;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

import java.util.Collection;

public class CustomUserDetails extends User {

    /**
     * 我们自定义的用户ID字段
     */
    private final Long id;

    public CustomUserDetails(Long id, String username, String password, Collection<? extends GrantedAuthority> authorities) {
        // 调用父类的构造函数
        super(username, password, authorities);
        // 设置我们自己的ID
        this.id = id;
    }

    // --- 新增的 getId() 方法 ---
    public Long getId() {
        return id;
    }
}