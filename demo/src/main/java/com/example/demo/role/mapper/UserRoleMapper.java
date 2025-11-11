package com.example.demo.role.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
@Mapper
public interface UserRoleMapper {
    /**
     * 为用户分配一个角色
     * @param userId 用户ID
     * @param roleId 角色ID
     */
    @Insert("INSERT INTO user_roles(user_id, role_id) VALUES(#{userId}, #{roleId})")
    void assignRoleToUser(@Param("userId") Long userId, @Param("roleId") Long roleId);
}