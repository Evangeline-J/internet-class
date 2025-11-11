package com.example.demo.role.mapper;
import com.example.demo.role.dto.Role;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import java.util.List;
import java.util.Set;

@Mapper
public interface RoleMapper {
    /**
     * 根据用户ID查询其拥有的所有角色名称列表 (您已有的方法)
     * @param userId 用户ID
     * @return 角色名称的字符串列表
     */
    @Select("SELECT r.id, r.name, r.code FROM roles r INNER JOIN user_roles ur ON r.id = ur.role_id WHERE ur.user_id = #{userId}")
    Set<Role> findRolesByUserId(Long userId);

    /**
     * --- 新增方法 ---
     * 根据角色名称查询完整的角色信息（包括ID）
     * @param code 角色名称 (例如 "user", "admin")
     * @return 角色对象
     */
    @Select("SELECT id, code FROM roles WHERE code = #{code}")
    Role findByCode(String code);
}
