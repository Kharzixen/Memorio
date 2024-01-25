package com.kharzixen.userrelationshipservice.listener;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kharzixen.userrelationshipservice.mapper.UserMapper;
import com.kharzixen.userrelationshipservice.model.User;
import com.kharzixen.userrelationshipservice.service.UserService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.support.KafkaHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Service;


@Service
@Slf4j
@AllArgsConstructor
public class UserTopicListener {

    private final ObjectMapper objectMapper;
    private final UserService userService;
    private final UserMapper userMapper;

    @KafkaListener(topics = "mongodb.users.user", groupId = "userEventConsumer")
    public void listen(@Payload(required = false) String message, @Header(KafkaHeaders.RECEIVED_KEY) String key) {
        log.info("Received message: " + message);
        try {
            JsonNode messagePayload = objectMapper.readTree(message).get("payload");
            //decide what to do based on the "operation" field
            switch (messagePayload.get("op").asText()) {
                case "c" -> {
                    User user = userMapper.jsonObjectToModel(messagePayload.get("after").asText());
                    userService.createUser(user);
                    log.info("User with id: {} created.", user.getUserId());
                }
                case "u" -> {
                    User newUser = userMapper.jsonObjectToModel(messagePayload.get("after").asText());
                    userService.updateUser(newUser.getUserId(), newUser.getPfpLink());
                    log.info("User with id: {} updated.", newUser.getUserId());
                }
                case "d" -> {
                    String userId = getDocumentIdFromKey(key);
                    userService.deleteUser(userId);
                    log.info("User with id: idk deleted.");
                }
                default -> log.warn("No operation field found.");
            }
            //log.info(jsonNode.get("payload").toString());
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
    }

    private String getDocumentIdFromKey(String key) throws JsonProcessingException {
        return objectMapper.readTree(objectMapper.readTree(key).get("payload").get("id").asText())
                .get("$oid").asText();
    }
}
