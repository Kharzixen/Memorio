package com.kharzixen.mediaservice.listener;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kharzixen.mediaservice.event.ContributorChangedEvent;
import com.kharzixen.mediaservice.event.MemoryEvent;
import com.kharzixen.mediaservice.service.AlbumService;
import io.minio.MinioClient;
import io.minio.RemoveObjectArgs;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.support.KafkaHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
@Slf4j
public class PrivateAlbumEventListener {
    private final ObjectMapper objectMapper;
    private final MinioClient minioClient;
    private final AlbumService albumService;

    @KafkaListener(topics = "memorio.albumdb_test.memory_event_outbox", groupId = "media-service-private-album-listener")
    public void memoryEventListener(@Payload(required = false) String message, @Header(KafkaHeaders.RECEIVED_KEY) String key) {
        log.info("Received private memory message: {}", message);

        try {
            JsonNode messagePayload = objectMapper.readTree(message).get("payload");
            MemoryEvent memoryEvent = objectMapper.readValue(messagePayload.get("after").toString(), MemoryEvent.class);
            String imageId = memoryEvent.getImageId().replace("-", "/");
            minioClient.removeObject(RemoveObjectArgs.builder().bucket("private-album-bucket").object(imageId).build());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @KafkaListener(topics = "memorio.albumdb_test.contributor_changed_event_outbox", groupId = "media-service-private-album-contributor-listener")
    public void contributorEventConsumer(@Payload(required = false) String message, @Header(KafkaHeaders.RECEIVED_KEY) String key) {
        log.info("Received private album contributor message: {}", message);
        try {
            JsonNode messagePayload = objectMapper.readTree(message).get("payload");
            ContributorChangedEvent contributorChangedEvent = objectMapper.readValue(messagePayload.get("after").toString(), ContributorChangedEvent.class);
            albumService.updateContributors(contributorChangedEvent);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }

}
