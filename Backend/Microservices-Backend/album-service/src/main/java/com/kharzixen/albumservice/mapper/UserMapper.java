package com.kharzixen.albumservice.mapper;

import com.kharzixen.albumservice.dto.outgoing.user.UserDtoOut;
import com.kharzixen.albumservice.dto.incomming.UserDtoIn;
import com.kharzixen.albumservice.model.User;
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


    User dtoToModel(UserDtoIn userDtoIn);

    List<UserDtoOut> modelsToDtos(List<User> users);

    @AfterMapping
    default void assignDefaultValues(UserDtoIn source, @MappingTarget User target){
        target.setOwnedAlbums(Collections.emptyList());
        target.setMemories(Collections.emptyList());
        target.setAlbums(Collections.emptyList());
        target.setCreatedCollections(Collections.emptyList());
    }

}
