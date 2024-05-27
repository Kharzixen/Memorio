package com.kharzixen.albumservice.kafkalistener;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kharzixen.albumservice.dto.incomming.UserDtoIn;
import com.kharzixen.albumservice.dto.outgoing.UserDtoOut;
import com.kharzixen.albumservice.event.UserEvent;
import com.kharzixen.albumservice.exception.DuplicateUserException;
import com.kharzixen.albumservice.mapper.UserMapper;
import com.kharzixen.albumservice.model.User;
import com.kharzixen.albumservice.service.UserService;
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

    @KafkaListener(topics = "user.userdb_test.user_outbox_table", groupId = "userEventConsumer")
    public void listen(@Payload(required = false) String message, @Header(KafkaHeaders.RECEIVED_KEY) String key) {
        log.info("Received message: " + message);
        try {
            JsonNode messagePayload = objectMapper.readTree(message).get("payload");
            UserEvent userEvent = objectMapper.readValue(messagePayload.get("after").toString(), UserEvent.class);
            //decide what to do based on the "operation" field
            switch (userEvent.getEventType()) {
                case "CREATE" -> {
                    UserDtoOut savedUser = userService.createUser(new UserDtoIn(userEvent.getUserId(),
                            userEvent.getUsername(), userEvent.getPfpId()));
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