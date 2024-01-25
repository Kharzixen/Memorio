package com.kharzixen.userrelationshipservice.mapper.impl;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kharzixen.userrelationshipservice.dto.incomming.UserDtoIn;
import com.kharzixen.userrelationshipservice.dto.outgoing.UserDtoOut;
import com.kharzixen.userrelationshipservice.dto.outgoing.UserDtoOutSimplified;
import com.kharzixen.userrelationshipservice.mapper.UserMapper;
import com.kharzixen.userrelationshipservice.model.User;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.HashSet;
import java.util.stream.Collectors;

@Component
@AllArgsConstructor
public class UserMapperImpl implements UserMapper {

    private final ObjectMapper objectMapper;

    @Override
    public User dtoToModel(UserDtoIn userDtoIn) {
        return User.builder()
                .userId(userDtoIn.getUserId())
                .pfpLink(userDtoIn.getPfpLink())
                .username(userDtoIn.getUsername())
                .followers(new HashSet<>())
                .following(new HashSet<>())
                .build();
    }

    @Override
    public UserDtoOutSimplified modelToSimplifiedDto(User user) {
        return UserDtoOutSimplified.builder()
                .userId(user.getUserId())
                .username(user.getUsername())
                .pfpLink(user.getPfpLink())
                .build();
    }

    @Override
    public User jsonObjectToModel(String jsonString) throws JsonProcessingException {
        JsonNode userObject = objectMapper.readTree(jsonString);
        String userId = userObject.get("_id").get("$oid").asText();
        String username = userObject.get("username").asText();
        String pfpLink = userObject.get("pfpLink").asText();
        User user = new User();
        user.setUserId(userId);
        user.setUsername(username);
        user.setPfpLink(pfpLink);
        user.setFollowingCount(0);
        user.setFollowersCount(0);

        return user;
    }

    @Override
    public UserDtoOut modelToDto(User user) {
        return UserDtoOut.builder()
                .userId(user.getUserId())
                .username(user.getUsername())
                .pfpLink(user.getPfpLink())
                .followersCount(user.getFollowersCount())
                .followingCount(user.getFollowingCount())
                .followers(user.getFollowers().stream().map(this::modelToSimplifiedDto).collect(Collectors.toSet()))
                .following(user.getFollowing().stream().map(this::modelToSimplifiedDto).collect(Collectors.toSet()))
                .build();
    }
}
