package com.example.demo.app.service;

import com.example.demo.app.dto.MenuDto;
import com.example.demo.app.mapper.MenuMapper;
import com.example.demo.role.dto.Role;
import com.example.demo.role.mapper.RoleMapper;
import com.example.demo.security.CustomUserDetails;
import com.example.demo.user.entity.Menu;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class MenuService {

    @Autowired
    private MenuMapper menuMapper;

    @Autowired
    private RoleMapper roleMapper;

    public List<MenuDto> getMenusForCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !(authentication.getPrincipal() instanceof CustomUserDetails)) {
            return new ArrayList<>();
        }

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();

        Set<Role> roles = roleMapper.findRolesByUserId(userId);
        List<Menu> userMenus;

        boolean isAdmin = roles.stream()
                .anyMatch(role -> "super_admin".equals(role.getCode()) || "admin".equals(role.getCode()));

        if (isAdmin) {
            userMenus = menuMapper.findAll();
        } else {
            Set<Long> roleIds = roles.stream().map(Role::getId).collect(Collectors.toSet());
            if (roleIds.isEmpty()) {
                return new ArrayList<>();
            }
            userMenus = menuMapper.findByRoleIds(roleIds);
        }

        // 使用修正后的方法构建树形结构
        return buildMenuTree(userMenus);
    }

    /**
     * 【已修正和优化】将扁平的菜单列表构建成树形结构
     * @param menus 从数据库查出的扁平菜单列表 (Menu 实体)
     * @return 供前端使用的树形结构菜单列表 (MenuDto)
     */
    private List<MenuDto> buildMenuTree(List<Menu> menus) {
        // 如果菜单列表为空，直接返回空列表
        if (menus == null || menus.isEmpty()) {
            return new ArrayList<>();
        }

        // 使用 Map 存储所有菜单的 DTO，键是菜单ID。这样可以快速通过ID找到任何一个菜单。
        // 使用 LinkedHashMap 保持插入顺序
        Map<Long, MenuDto> menuDtoMap = new LinkedHashMap<>();

        // 第一次遍历：将所有的 Menu 实体转换为 MenuDto，并存入 Map
        for (Menu menu : menus) {
            MenuDto dto = new MenuDto();
            BeanUtils.copyProperties(menu, dto);
            // 确保 children 列表被初始化，避免后续出现 NullPointerException
            dto.setChildren(new ArrayList<>());
            menuDtoMap.put(dto.getId(), dto);
        }

        // 最终要返回的顶级菜单列表
        List<MenuDto> rootMenus = new ArrayList<>();

        // 第二次遍历：利用原始的 Menu 列表中的 parentId 信息来构建父子关系
        for (Menu menu : menus) {
            // 从 Map 中获取当前菜单对应的 DTO
            MenuDto currentDto = menuDtoMap.get(menu.getId());
            Long parentId = menu.getParentId(); // <-- 关键：从原始的 menu 对象获取 parentId

            // 判断是否为顶级菜单 (parentId 为 null 或 0)
            if (parentId == null || parentId == 0L) {
                rootMenus.add(currentDto);
            } else {
                // 如果不是顶级菜单，就从 Map 中找到它的父菜单 DTO
                MenuDto parentDto = menuDtoMap.get(parentId);
                if (parentDto != null) {
                    // 将当前菜单 DTO 添加到其父菜单的 children 列表中
                    parentDto.getChildren().add(currentDto);
                }
                // (可选) 如果找不到父菜单（数据不一致），可以考虑也将其作为顶级菜单处理
                // else { rootMenus.add(currentDto); }
            }
        }

        return rootMenus;
    }
}