package com.kharzixen.postservice.mapper;

import com.kharzixen.postservice.dto.incomming.UserDtoIn;
import com.kharzixen.postservice.dto.outgoing.UserDtoOut;
import com.kharzixen.postservice.model.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;


@Mapper(componentModel = "spring")
public interface UserMapper {
    UserMapper INSTANCE = Mappers.getMapper(UserMapper.class);

    @Mapping(target="userId", source = "id")
    UserDtoOut modelToDto(User user);

    User dtoToModel(UserDtoIn userDtoIn);
}
