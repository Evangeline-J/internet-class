package com.example.demo.auth.dto;

/**
 * 用于接收管理员删除用户请求的 JSON Body
 * 例如: { "userId": 99 }
 */
public class DeleteUserRequest {

    private Long userId;

    // --- Getter and Setter ---

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }
}