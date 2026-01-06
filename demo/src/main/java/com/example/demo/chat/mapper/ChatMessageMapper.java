package com.example.demo.chat.mapper;

import com.example.demo.chat.entity.ChatMessage;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface ChatMessageMapper {

    @Insert("""
        INSERT INTO chat_message(session_id, user_id, role, content, created_at)
        VALUES(#{sessionId}, #{userId}, #{role}, #{content}, NOW())
        """)
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(ChatMessage msg);

    @Select("""
        SELECT id, session_id, user_id, role, content, created_at
        FROM chat_message
        WHERE session_id = #{sessionId}
        ORDER BY id ASC
        LIMIT #{limit}
        OFFSET #{offset}
        """)
    List<ChatMessage> listBySession(@Param("sessionId") Long sessionId, @Param("limit") int limit, @Param("offset") int offset);

    @Delete("DELETE FROM chat_message WHERE session_id = #{sessionId}")
    int deleteBySession(@Param("sessionId") Long sessionId);
}




