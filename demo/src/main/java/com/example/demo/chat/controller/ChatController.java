package com.example.demo.chat.controller;

import com.example.demo.chat.dto.ChatMessageDto;
import com.example.demo.chat.dto.CreateSessionRequest;
import com.example.demo.chat.dto.SendMessageRequest;
import com.example.demo.chat.entity.ChatSession;
import com.example.demo.chat.service.ChatService;
import com.example.demo.common.ApiResponse;
import com.example.demo.security.CustomUserDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/chat")
public class ChatController {

    @Autowired
    private ChatService chatService;

    private Long currentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Object p = auth.getPrincipal();
        if (p instanceof CustomUserDetails u) return u.getId();
        return null;
    }

    @PostMapping("/sessions")
    public ApiResponse<ChatSession> createSession(@RequestBody(required = false) CreateSessionRequest req) {
        Long userId = currentUserId();
        ChatSession s = chatService.createSession(userId, req == null ? null : req.getTitle());
        return ApiResponse.ok(s);
    }

    @GetMapping("/sessions")
    public ApiResponse<List<ChatSession>> listSessions() {
        Long userId = currentUserId();
        return ApiResponse.ok(chatService.listSessions(userId));
    }

    @DeleteMapping("/sessions/{id}")
    public ResponseEntity<?> deleteSession(@PathVariable("id") Long id) {
        Long userId = currentUserId();
        chatService.deleteSession(userId, id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/sessions/{id}/messages")
    public ApiResponse<List<ChatMessageDto>> listMessages(@PathVariable("id") Long id) {
        Long userId = currentUserId();
        return ApiResponse.ok(chatService.listMessages(userId, id));
    }

    @PostMapping("/sessions/{id}/messages")
    public ApiResponse<ChatMessageDto> sendMessage(@PathVariable("id") Long id, @RequestBody SendMessageRequest req) {
        Long userId = currentUserId();
        ChatMessageDto dto = chatService.sendMessage(userId, id, req.getContent());
        return ApiResponse.ok(dto);
    }
}




