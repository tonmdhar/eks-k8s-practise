package com.practise.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

@RestController
public class ApiController {
    private final AtomicInteger requestCount = new AtomicInteger(0);

    @GetMapping("/api/data")
    public ResponseEntity<Map<String, String>> getData() {
        int count = requestCount.incrementAndGet();
        Map<String, String> response = new HashMap<>();
        response.put("message", "Production practice environment");
        response.put("requests", String.valueOf(count));
        return ResponseEntity.ok(response);
    }

    @GetMapping("/health")
    public Map<String, String> healthCheck() {
        return Map.of("status", "UP", "timestamp", String.valueOf(System.currentTimeMillis()));
    }
}