package com.example.demo.user.mapper;

import com.example.demo.user.entity.User;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Select;

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
}
