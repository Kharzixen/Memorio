package com.kharzixen.publicalbumservice.kafkalistener;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import com.kharzixen.publicalbumservice.dto.incomming.UserDtoIn;
import com.kharzixen.publicalbumservice.dto.outgoing.UserDtoOut;
import com.kharzixen.publicalbumservice.exception.DuplicateUserException;
import com.kharzixen.publicalbumservice.service.UserService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.support.KafkaHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Service;
import com.kharzixen.publicalbumservice.event.UserEvent;

@Service
@Slf4j
@AllArgsConstructor
public class UserTopicListener {

    private final ObjectMapper objectMapper;
    private final UserService userService;

    @KafkaListener(topics = "memorio.authentication_db.user_outbox")
    public void listen(@Payload(required = false) String message, @Header(KafkaHeaders.RECEIVED_KEY) String key) {
        log.info("Received message: {}", message);
        try {
            JsonNode messagePayload = objectMapper.readTree(message).get("payload");
            UserEvent userEvent = objectMapper.readValue(messagePayload.get("after").toString(), UserEvent.class);
            //decide what to do based on the "operation" field
            switch (userEvent.getMethod()) {
                case "CREATE" -> {
                    UserDtoIn userDtoIn = UserDtoIn.builder()
                            .id(userEvent.getUserId())
                            .username(userEvent.getUsername())
                            .isActive(userEvent.getIsActive())
                            .isAdmin(userEvent.getIsAdmin())
                            .build();
                    UserDtoOut savedUser = userService.createUser(userDtoIn);
                    log.info("User with id: {} created.", savedUser.getId());
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