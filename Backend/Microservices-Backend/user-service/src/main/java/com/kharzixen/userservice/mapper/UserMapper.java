package com.kharzixen.userservice.mapper;

import com.kharzixen.userservice.dto.incomming.UserDtoIn;
import com.kharzixen.userservice.dto.incomming.UserPatchDtoIn;
import com.kharzixen.userservice.dto.outgoing.UserDtoOut;
import com.kharzixen.userservice.dto.outgoing.SimpleUserDtoOut;
import com.kharzixen.userservice.model.User;
import com.kharzixen.userservice.projection.SimpleUserProjection;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper(componentModel = "spring")
public interface UserMapper {
    UserMapper INSTANCE = Mappers.getMapper(UserMapper.class);

    @Mapping(target = "userId", source = "id")
    UserDtoOut modelToDto(User user);


    SimpleUserDtoOut modelToSimplifiedDto(User user);


    SimpleUserDtoOut projectionToDto(SimpleUserProjection projection);


    @Mapping(target = "pfpId", ignore = true)
    @Mapping(target = "accountCreationDate", ignore = true)
    User dtoToModel(UserDtoIn userDtoIn);

    List<UserDtoOut> modelsToDtos(List<User> users);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "accountCreationDate", ignore = true)
    User dtoPatchToModel(UserPatchDtoIn dtoIn);

}
