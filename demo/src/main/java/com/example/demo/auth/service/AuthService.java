package com.example.demo.auth.service;

import com.example.demo.auth.dto.LoginResponse;
import com.example.demo.user.dto.LoginRequest;

public interface AuthService {
    LoginResponse login(LoginRequest loginRequest);
}