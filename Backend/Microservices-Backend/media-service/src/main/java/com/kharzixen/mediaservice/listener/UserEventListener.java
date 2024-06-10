package com.kharzixen.mediaservice.listener;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kharzixen.mediaservice.event.UserEvent;
import com.kharzixen.mediaservice.exception.DuplicateUserException;
import com.kharzixen.mediaservice.model.User;
import com.kharzixen.mediaservice.repository.UserRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.hibernate.annotations.Comment;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.support.KafkaHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Service;

@AllArgsConstructor
@Service
@Slf4j
public class UserEventListener {
    private final ObjectMapper objectMapper;
    private final UserRepository userRepository;

    @KafkaListener(topics = "memorio.authentication_db.user_outbox", groupId = "media-service-user-listener")
    public void listen(@Payload(required = false) String message, @Header(KafkaHeaders.RECEIVED_KEY) String key) {
        log.info("Received message: {}", message);
        try {
            JsonNode messagePayload = objectMapper.readTree(message).get("payload");
            UserEvent userEvent = objectMapper.readValue(messagePayload.get("after").toString(), UserEvent.class);
            //decide what to do based on the "operation" field
            switch (userEvent.getMethod()) {
                case "CREATE" -> {
                    if(userRepository.findById(userEvent.getUserId()).isEmpty()){
                        User user = User.builder()
                                .userId(userEvent.getUserId())
                                .pfpId("default_pfp_id.jpg")
                                .username(userEvent.getUsername())

                                .build();
                        userRepository.save(user);
                    } else {
                        throw new DuplicateUserException("User with id: "+ userEvent.getUserId() + "is duplicate");
                    }
                }
                case "DELETE" -> {

                }
                default -> log.warn("No operation field found.");
            }
            //log.info(jsonNode.get("payload").toString());
        } catch (JsonProcessingException | DuplicateUserException e) {
            log.info(e.getMessage());
        }
    }

    private String getDocumentIdFromKey(String key) throws JsonProcessingException {
        return objectMapper.readTree(objectMapper.readTree(key).get("payload").get("id").asText())
                .get("$oid").asText();
    }
}
