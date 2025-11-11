package com.example.demo.app.mapper;

import com.example.demo.user.entity.Menu;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Set;

@Mapper
public interface MenuMapper {

    /**
     * 查询所有菜单信息
     * @return 所有菜单列表
     */
    @Select("SELECT * FROM menus WHERE is_visible = 1 ORDER BY sort_order ASC")
    List<Menu> findAll();

    /**
     * 根据角色ID列表查询对应的所有菜单信息
     * @param roleIds 角色ID集合
     * @return 菜单列表
     */
    @Select("""
        <script>
            SELECT DISTINCT m.*
            FROM menus m
            LEFT JOIN role_menus rm ON m.id = rm.menu_id
            WHERE m.is_visible = 1
            AND rm.role_id IN
            <foreach item='item' index='index' collection='roleIds' open='(' separator=',' close=')'>
                #{item}
            </foreach>
            ORDER BY m.sort_order ASC
        </script>
    """)
    List<Menu> findByRoleIds(Set<Long> roleIds);
}
