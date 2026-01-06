package com.example.demo.chat.service.impl;

import com.example.demo.chat.dto.ChatMessageDto;
import com.example.demo.chat.entity.ChatMessage;
import com.example.demo.chat.entity.ChatSession;
import com.example.demo.chat.mapper.ChatMessageMapper;
import com.example.demo.chat.mapper.ChatSessionMapper;
import com.example.demo.chat.service.ChatService;
import com.example.demo.chat.service.DeepSeekClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class ChatServiceImpl implements ChatService {

    @Autowired
    private ChatSessionMapper sessionMapper;
    @Autowired
    private ChatMessageMapper messageMapper;
    @Autowired
    private DeepSeekClient deepSeekClient;

    @Override
    public ChatSession createSession(Long userId, String title) {
        ChatSession s = new ChatSession();
        s.setUserId(userId);
        s.setTitle((title == null || title.isBlank()) ? "新会话" : title.trim());
        sessionMapper.insert(s);
        return s;
    }

    @Override
    public List<ChatSession> listSessions(Long userId) {
        return sessionMapper.listByUser(userId);
    }

    @Override
    @Transactional
    public void deleteSession(Long userId, Long sessionId) {
        // 软删除会话，并清理消息
        sessionMapper.softDelete(sessionId, userId);
        messageMapper.deleteBySession(sessionId);
    }

    @Override
    public List<ChatMessageDto> listMessages(Long userId, Long sessionId) {
        // 为简单起见，不再检查 userId/sessionId 关系的每一步，生产应加强
        return messageMapper.listBySession(sessionId, 200, 0)
                .stream()
                .map(m -> new ChatMessageDto(m.getId(), m.getRole(), m.getContent(), m.getCreatedAt()))
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public ChatMessageDto sendMessage(Long userId, Long sessionId, String content) {
        // 保存用户消息
        ChatMessage userMsg = new ChatMessage();
        userMsg.setSessionId(sessionId);
        userMsg.setUserId(userId);
        userMsg.setRole("user");
        userMsg.setContent(content);
        messageMapper.insert(userMsg);
        sessionMapper.touch(sessionId);

        // 组装上下文（取最近 30 条）
        List<ChatMessage> recent = messageMapper.listBySession(sessionId, 30, 0);
        List<Map<String,String>> msgs = new ArrayList<>();
        for (ChatMessage m : recent) {
            msgs.add(Map.of("role", m.getRole(), "content", m.getContent()));
        }

        // 调用 DeepSeek
        String assistant = deepSeekClient.chat(msgs);

        // 保存助手消息
        ChatMessage bot = new ChatMessage();
        bot.setSessionId(sessionId);
        bot.setUserId(userId);
        bot.setRole("assistant");
        bot.setContent(assistant);
        messageMapper.insert(bot);
        sessionMapper.touch(sessionId);

        return new ChatMessageDto(bot.getId(), bot.getRole(), bot.getContent(), bot.getCreatedAt());
    }
}




