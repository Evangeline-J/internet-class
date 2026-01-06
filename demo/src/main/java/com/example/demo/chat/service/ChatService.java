package com.example.demo.chat.service;

import com.example.demo.chat.dto.ChatMessageDto;
import com.example.demo.chat.entity.ChatSession;

import java.util.List;

public interface ChatService {
    ChatSession createSession(Long userId, String title);
    List<ChatSession> listSessions(Long userId);
    void deleteSession(Long userId, Long sessionId);
    List<ChatMessageDto> listMessages(Long userId, Long sessionId);
    ChatMessageDto sendMessage(Long userId, Long sessionId, String content);
}




