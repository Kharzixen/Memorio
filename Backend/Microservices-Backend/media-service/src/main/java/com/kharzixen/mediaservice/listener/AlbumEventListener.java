package com.kharzixen.mediaservice.listener;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kharzixen.mediaservice.event.MemoryEvent;
import io.minio.MinioClient;
import io.minio.RemoveObjectArgs;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.support.KafkaHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
@Slf4j
public class AlbumEventListener {
    private final ObjectMapper objectMapper;
    private final MinioClient minioClient;


    @KafkaListener(topics = "album.albumdb_test.memory_event_outbox", groupId = "albumEventConsumer")
    public void listen(@Payload(required = false) String message, @Header(KafkaHeaders.RECEIVED_KEY) String key) {
        log.info("Received message: {}", message);



        try {
            JsonNode messagePayload = objectMapper.readTree(message).get("payload");
            MemoryEvent memoryEvent = objectMapper.readValue(messagePayload.get("after").toString(), MemoryEvent.class);
            String imageId = memoryEvent.getImageId().replace("-", "/");
            minioClient.removeObject(RemoveObjectArgs.builder().bucket("default").object(imageId).build());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
