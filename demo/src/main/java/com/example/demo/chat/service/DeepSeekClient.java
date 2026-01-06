package com.example.demo.chat.service;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
public class DeepSeekClient {
    // TODO: 将你的真实 API Key 放到这里
    private static final String API_KEY = "sk-gweplxrregnljhdqnjcenoogbyiajicsshlgrdhlfnfanecg";
    private static final String ENDPOINT = "https://api.siliconflow.cn/v1/chat/completions";
    private static final String MODEL = "deepseek-ai/DeepSeek-R1-Distill-Qwen-7B";

    private final RestTemplate restTemplate = new RestTemplate();

    @SuppressWarnings("unchecked")
    public String chat(List<Map<String, String>> messages) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(API_KEY);

        Map<String, Object> body = new HashMap<>();
        body.put("model", MODEL);
        body.put("messages", messages);
        body.put("temperature", 0.7);

        HttpEntity<Map<String, Object>> request = new HttpEntity<>(body, headers);
        Map<String, Object> resp = restTemplate.postForObject(ENDPOINT, request, Map.class);
        if (resp == null) return "对不起，我现在没有响应。";
        try {
            List<Map<String,Object>> choices = (List<Map<String,Object>>) resp.get("choices");
            if (choices != null && !choices.isEmpty()) {
                Map<String,Object> msg = (Map<String,Object>) choices.get(0).get("message");
                if (msg != null && msg.get("content") != null) {
                    return String.valueOf(msg.get("content"));
                }
            }
        } catch (Exception ignored) {}
        return "对不起，我现在没有响应。";
    }
}




