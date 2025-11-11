package com.example.demo.user.mapper;

import com.example.demo.user.entity.User;
import org.apache.ibatis.annotations.*;

import java.util.Optional;

@Mapper
public interface UserMapper {

    // SELECT * 会自动映射所有新字段，无需修改
    @Select("SELECT * FROM users WHERE username = #{username}")
    User findByUsername(String username);

    @Select("SELECT * FROM users WHERE email = #{email}")
    User findByEmail(String email);

    // --- INSERT 语句已更新 ---
    // 1. 将 `password` 列修改为 `password_hash`。
    // 2. 移除了 status, created_at, updated_at，因为数据库会自动设置默认值。
    @Insert("INSERT INTO users(username, email, password_hash, phone, nickname) " +
            "VALUES(#{username}, #{email}, #{passwordHash}, #{phone}, #{nickname})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    void insert(User user);

    /**
     * 根据用户ID查询用户信息。
     * 返回 Optional<User> 是一种更安全的做法，可以有效避免空指针异常。
     * @param id 用户ID
     * @return 包含用户信息的 Optional 对象，如果用户不存在则为空
     */
    @Select("SELECT * FROM users WHERE id = #{id}")
    Optional<User> findById(Long id);

    /**
     * 根据用户ID删除用户。
     * @param id 用户ID
     * @return 返回受影响的行数 (成功删除应返回 1)
     */
    @Delete("DELETE FROM users WHERE id = #{id}")
    int deleteById(Long id);
}

