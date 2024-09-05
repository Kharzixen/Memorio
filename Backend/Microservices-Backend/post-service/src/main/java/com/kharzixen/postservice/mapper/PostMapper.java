package com.kharzixen.postservice.mapper;

import com.kharzixen.postservice.dto.incomming.PostDtoIn;
import com.kharzixen.postservice.dto.outgoing.PostDtoOut;
import com.kharzixen.postservice.model.Post;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

@Mapper(componentModel = "spring")
public interface PostMapper {
    PostMapper INSTANCE = Mappers.getMapper(PostMapper.class);

    @Mapping(target = "isLikedByRequester", ignore = true)
    @Mapping(target = "likeCount", ignore = true)
    @Mapping(target="owner.userId", source = "owner.id")
    PostDtoOut modelToDto(Post post);

}
