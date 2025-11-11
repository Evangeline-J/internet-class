package com.example.demo.app.controller;

import com.example.demo.app.dto.MenuDto;
import com.example.demo.app.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/menus")
public class MenuController {

    @Autowired
    private MenuService menuService;

    /**
     * 获取当前登录用户的动态菜单
     * @return 树形结构的菜单列表
     */
    @GetMapping
    public ResponseEntity<List<MenuDto>> getCurrentUserMenus() {
        List<MenuDto> menus = menuService.getMenusForCurrentUser();
        return ResponseEntity.ok(menus);
    }
}
