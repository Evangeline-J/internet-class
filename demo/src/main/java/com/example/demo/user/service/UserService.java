package com.example.demo.user.service;

import com.example.demo.user.dto.RegisterRequest;
import com.example.demo.user.entity.User;

public interface UserService {
    User register(RegisterRequest registerRequest);
}
