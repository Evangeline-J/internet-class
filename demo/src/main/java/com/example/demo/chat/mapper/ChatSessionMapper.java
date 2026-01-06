package com.example.demo.chat.mapper;

import com.example.demo.chat.entity.ChatSession;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface ChatSessionMapper {

    @Insert("""
        INSERT INTO chat_session(user_id, title, created_at, updated_at)
        VALUES(#{userId}, #{title}, NOW(), NOW())
        """)
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(ChatSession session);

    @Select("""
        SELECT id, user_id, title, created_at, updated_at, deleted_at
        FROM chat_session
        WHERE user_id = #{userId} AND deleted_at IS NULL
        ORDER BY updated_at DESC
        """)
    List<ChatSession> listByUser(@Param("userId") Long userId);

    @Update("""
        UPDATE chat_session SET title = #{title}, updated_at = NOW()
        WHERE id = #{id} AND user_id = #{userId}
        """)
    int updateTitle(@Param("id") Long id, @Param("userId") Long userId, @Param("title") String title);

    @Update("""
        UPDATE chat_session SET deleted_at = NOW()
        WHERE id = #{id} AND user_id = #{userId}
        """)
    int softDelete(@Param("id") Long id, @Param("userId") Long userId);

    @Update("""
        UPDATE chat_session SET updated_at = NOW()
        WHERE id = #{id}
        """)
    int touch(@Param("id") Long id);

    @Select("SELECT id, user_id, title, created_at, updated_at, deleted_at FROM chat_session WHERE id = #{id} AND user_id = #{userId} AND deleted_at IS NULL")
    ChatSession findById(@Param("id") Long id, @Param("userId") Long userId);
}




