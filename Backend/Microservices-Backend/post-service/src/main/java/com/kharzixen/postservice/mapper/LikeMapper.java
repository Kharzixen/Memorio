package com.kharzixen.postservice.mapper;

import com.kharzixen.postservice.dto.outgoing.LikeDtoOut;
import com.kharzixen.postservice.model.Like;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

@Mapper(componentModel = "spring")
public interface LikeMapper {
    LikeMapper INSTANCE = Mappers.getMapper(LikeMapper.class);

    @Mapping(target="user.userId", source = "user.id")
    LikeDtoOut modelToDto(Like like);
}
