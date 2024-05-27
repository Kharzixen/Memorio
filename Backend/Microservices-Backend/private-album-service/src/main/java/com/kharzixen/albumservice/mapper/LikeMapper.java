package com.kharzixen.albumservice.mapper;

import com.kharzixen.albumservice.dto.outgoing.LikeDtoOut;
import com.kharzixen.albumservice.model.Like;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

@Mapper(componentModel = "spring")
public interface LikeMapper {
    LikeMapper INSTANCE = Mappers.getMapper(LikeMapper.class);

    LikeDtoOut modelToDto(Like like);
}
