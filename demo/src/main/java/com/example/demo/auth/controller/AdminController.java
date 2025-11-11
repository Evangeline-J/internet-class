package com.example.demo.auth.controller;

import com.example.demo.auth.dto.DeleteUserRequest;
import com.example.demo.auth.service.AdminService; // <-- 【重要】确保导入的是接口
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/admin")
public class AdminController {

    // 【重要】依赖注入的是接口，而不是实现类
    private final AdminService adminService;

    @Autowired
    public AdminController(AdminService adminService) {
        this.adminService = adminService;
    }

    @PostMapping("/delete-user")
    @PreAuthorize("hasAnyRole('super_admin', 'admin')")
    public ResponseEntity<?> deleteUser(@RequestBody DeleteUserRequest request) {
        // 控制器代码无需任何改变，它只与接口交互
        adminService.deleteUser(request.getUserId());

        return ResponseEntity.ok(Map.of(
                "message", "User deletion process initiated successfully by admin."
        ));
    }
}