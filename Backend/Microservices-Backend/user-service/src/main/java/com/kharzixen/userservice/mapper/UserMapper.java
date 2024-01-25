package com.kharzixen.userservice.mapper;

import com.kharzixen.userservice.dto.incomming.UserDtoIn;
import com.kharzixen.userservice.dto.incomming.UserPatchDtoIn;
import com.kharzixen.userservice.dto.outgoing.UserDtoOut;
import com.kharzixen.userservice.dto.outgoing.UserSimplifiedDtoOut;
import com.kharzixen.userservice.model.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper(componentModel = "spring")
public interface UserMapper {
    UserMapper INSTANCE = Mappers.getMapper(UserMapper.class);

    @Mapping(target = "userId", source = "id")
    UserDtoOut modelToDto(User user);

    @Mapping(target = "userId", source = "id")
    UserSimplifiedDtoOut modelToSimplifiedDto(User user);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "pfpLink", ignore = true)
    @Mapping(target = "accountCreationDate", ignore = true)
    User dtoToModel(UserDtoIn userDtoIn);

    List<UserDtoOut> modelsToDtos(List<User> users);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "accountCreationDate", ignore = true)
    User dtoPatchToModel(UserPatchDtoIn dtoIn);

}
