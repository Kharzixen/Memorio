package com.kharzixen.userservice.listener;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kharzixen.userservice.dto.incomming.UserDtoIn;
import com.kharzixen.userservice.dto.outgoing.UserDtoOut;
import com.kharzixen.userservice.event.UserEvent;
import com.kharzixen.userservice.service.UserService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.support.KafkaHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
@Slf4j
@AllArgsConstructor
public class UserTopicListener {

    private final ObjectMapper objectMapper;
    private final UserService userService;

    @KafkaListener(topics = "memorio.authentication_db.user_outbox")
    public void listen(@Payload(required = false) String message, @Header(KafkaHeaders.RECEIVED_KEY) String key) {
        log.info("Received message: " + message);
        try {
            JsonNode messagePayload = objectMapper.readTree(message).get("payload");
            UserEvent userEvent = objectMapper.readValue(messagePayload.get("after").toString(), UserEvent.class);
            //decide what to do based on the "operation" field
            switch (userEvent.getMethod()) {
                case "CREATE" -> {

                    UserDtoIn userDtoIn = UserDtoIn.builder()
                            .id(userEvent.getUserId())
                            .name(userEvent.getName())
                            .email(userEvent.getEmail())
                            .username(userEvent.getUsername())
                            //the birthday comes as a timestamp with microseconds, that's why the conversion
                            .birthday(new Date(userEvent.getBirthday()/1000))
                            .bio("")
                            .isAdmin(userEvent.getIsAdmin())
                            .isActive(userEvent.getIsActive())
                            .build();
                    UserDtoOut savedUser = userService.createUser(userDtoIn);
                    log.info("User with id: {} created.", userEvent.getId());
                }
                case "DELETE" -> {

                }
                default -> log.warn("No operation field found.");
            }
            //log.info(jsonNode.get("payload").toString());
        } catch (Exception e) {
            log.info(e.getMessage());
        }
    }

    private String getDocumentIdFromKey(String key) throws JsonProcessingException {
        return objectMapper.readTree(objectMapper.readTree(key).get("payload").get("id").asText())
                .get("$oid").asText();
    }
}