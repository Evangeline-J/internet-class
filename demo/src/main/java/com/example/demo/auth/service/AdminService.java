package com.example.demo.auth.service;

/**
 * 管理员服务接口
 * 定义了所有管理员相关的业务操作
 */
public interface AdminService {

    /**
     * 根据用户ID删除一个用户
     * @param userId 要删除的用户ID
     */
    void deleteUser(Long userId);

}