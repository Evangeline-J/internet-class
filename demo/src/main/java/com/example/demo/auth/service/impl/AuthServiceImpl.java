package com.example.demo.auth.service.impl;

import com.example.demo.auth.dto.LoginResponse;
import com.example.demo.auth.service.AuthService;
import com.example.demo.role.dto.Role; // <-- 1. 确保导入 Role 类
import com.example.demo.role.mapper.RoleMapper;
import com.example.demo.security.JwtTokenProvider;
import com.example.demo.user.dto.LoginRequest;
import com.example.demo.user.entity.User;
import com.example.demo.user.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Set; // <-- 2. 导入 Set
import java.util.stream.Collectors; // <-- 3. 导入 Collectors 用于 Stream API

@Service
public class AuthServiceImpl implements AuthService {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtTokenProvider tokenProvider;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private RoleMapper roleMapper;

    @Value("${jwt.expiration-ms}")
    private long expiresIn;

    @Override
    public LoginResponse login(LoginRequest loginRequest) {
        // Authenticate the user using Spring Security
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        loginRequest.getUsername(),
                        loginRequest.getPassword()
                )
        );

        // Set the authentication in the security context
        SecurityContextHolder.getContext().setAuthentication(authentication);

        // Generate JWT token
        String token = tokenProvider.generateToken(authentication);
        String refreshToken = tokenProvider.generateRefreshToken(authentication);

        // Fetch user details for the response
        User user = userMapper.findByUsername(loginRequest.getUsername());
        if (user == null) {
            user = userMapper.findByEmail(loginRequest.getUsername());
        }

        // --- 【核心修改部分】 ---
        // 4. 首先，接收 Mapper 返回的 Set<Role> 对象
        Set<Role> userRoles = roleMapper.findRolesByUserId(user.getId());

        // 5. 然后，将 Set<Role> 转换为前端需要的 List<String> (我们使用 role 的 code 字段)
        List<String> roleCodes = userRoles.stream()
                .map(Role::getCode) // 对于每个 Role 对象，提取其 code 字符串
                .collect(Collectors.toList()); // 将所有 code 收集成一个 List

        // Build user info for response
        LoginResponse.UserInfo userInfo = LoginResponse.UserInfo.builder()
                .id(user.getId())
                .username(user.getUsername())
                .email(user.getEmail())
                .nickname(user.getNickname())
                .roles(roleCodes) // <-- 6. 使用转换后的角色代码列表
                .build();

        // Build the final response
        return LoginResponse.builder()
                .token(token)
                .refreshToken(refreshToken)
                .expiresIn(expiresIn / 1000) // convert ms to seconds
                .user(userInfo)
                .build();
    }
}