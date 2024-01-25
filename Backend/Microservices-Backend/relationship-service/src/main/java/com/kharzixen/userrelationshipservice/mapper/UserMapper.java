package com.kharzixen.userrelationshipservice.mapper;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.kharzixen.userrelationshipservice.dto.incomming.UserDtoIn;
import com.kharzixen.userrelationshipservice.dto.outgoing.UserDtoOut;
import com.kharzixen.userrelationshipservice.dto.outgoing.UserDtoOutSimplified;
import com.kharzixen.userrelationshipservice.model.User;
import org.springframework.stereotype.Component;


public interface UserMapper {
    User dtoToModel(UserDtoIn userDtoIn);
    UserDtoOut modelToDto(User user);
    UserDtoOutSimplified modelToSimplifiedDto(User user);

    User jsonObjectToModel(String jsonString) throws JsonProcessingException;

}
