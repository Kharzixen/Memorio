package com.kharzixen.publicalbumservice.mapper;


import com.kharzixen.publicalbumservice.dto.incomming.UserDtoIn;
import com.kharzixen.publicalbumservice.dto.outgoing.UserDtoOut;
import com.kharzixen.publicalbumservice.model.User;
import com.kharzixen.publicalbumservice.projection.UserProjection;
import org.mapstruct.AfterMapping;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import org.mapstruct.factory.Mappers;

import java.util.Collections;
import java.util.List;

@Mapper(componentModel = "spring")
public interface UserMapper {
    UserMapper INSTANCE = Mappers.getMapper(UserMapper.class);

    UserDtoOut modelToDto(User user);

    UserDtoOut projectionToDto(UserProjection userProjection);


    User dtoToModel(UserDtoIn userDtoIn);

    List<UserDtoOut> modelsToDtos(List<User> users);



}
