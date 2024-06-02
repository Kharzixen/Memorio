package com.kharzixen.publicalbumservice.mapper;


import com.kharzixen.publicalbumservice.dto.outgoing.LikeDtoOut;
import com.kharzixen.publicalbumservice.model.Like;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

@Mapper(componentModel = "spring")
public interface LikeMapper {
    LikeMapper INSTANCE = Mappers.getMapper(LikeMapper.class);

    LikeDtoOut modelToDto(Like like);
}
