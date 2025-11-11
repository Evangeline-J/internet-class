package com.example.demo.auth.controller;

import com.example.demo.user.dto.RegisterRequest;
import com.example.demo.user.dto.UserResponse;
import com.example.demo.user.entity.User;
import com.example.demo.user.service.UserService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.AuthenticationException;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import com.example.demo.auth.dto.LoginResponse;
import com.example.demo.auth.service.AuthService;
import com.example.demo.user.dto.LoginRequest;


import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/auth")
@CrossOrigin(origins = "http://localhost:5173")
public class AuthController {

    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);

    @Autowired
    private UserService userService;

    @Autowired
    private AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@Validated @RequestBody LoginRequest loginRequest) {
        Map<String, Object> response = new HashMap<>();
        try {
            // --- 在这里添加日志打印 ---
            logger.info("Login attempt for username: '{}'", loginRequest.getUsername());
            logger.info("Password received: '{}'", loginRequest.getPassword());
            // -------------------------

            LoginResponse loginData = authService.login(loginRequest);
            response.put("code", 0);
            response.put("message", "登录成功");
            response.put("data", loginData);
            response.put("timestamp", Instant.now().toEpochMilli());
            return ResponseEntity.ok(response);
        } catch (AuthenticationException e) {
            response.put("code", 401); // 401 Unauthorized
            response.put("message", "登录失败：用户名或密码错误");
            response.put("data", null);
            response.put("timestamp", Instant.now().toEpochMilli());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }
    }
    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> register(@Validated @RequestBody RegisterRequest registerRequest) {
        Map<String, Object> response = new HashMap<>();
        try {
            User registeredUser = userService.register(registerRequest);
            UserResponse userResponse = new UserResponse();
            BeanUtils.copyProperties(registeredUser, userResponse);

            response.put("code", 0);
            response.put("message", "注册成功");
            response.put("data", userResponse);
            response.put("timestamp", Instant.now().toEpochMilli());
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            // 建议使用全局异常处理器 @ControllerAdvice 来统一处理
            response.put("code", 409); // 409 Conflict
            response.put("message", e.getMessage());
            response.put("data", null);
            response.put("timestamp", Instant.now().toEpochMilli());
            return ResponseEntity.status(HttpStatus.CONFLICT).body(response);
        }
    }
}
