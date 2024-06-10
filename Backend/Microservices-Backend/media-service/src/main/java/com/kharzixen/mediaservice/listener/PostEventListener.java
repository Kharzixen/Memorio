package com.kharzixen.mediaservice.listener;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kharzixen.mediaservice.event.PostChangedEvent;
import com.kharzixen.mediaservice.service.PostService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.support.KafkaHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@AllArgsConstructor
public class PostEventListener {
    private final PostService postService;
    private final ObjectMapper objectMapper;

    @KafkaListener(topics = "memorio.postdb_test.post_outbox", groupId = "media-service-post-listener")
    public void listenPostEvent(@Payload(required = false) String message, @Header(KafkaHeaders.RECEIVED_KEY) String key) {
        log.info("Received post message: {}", message);
        try {
            JsonNode messagePayload = objectMapper.readTree(message).get("payload");
            PostChangedEvent contributorChangedEvent = objectMapper.readValue(messagePayload.get("after").toString(), PostChangedEvent.class);
            postService.handlePostChange(contributorChangedEvent);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
