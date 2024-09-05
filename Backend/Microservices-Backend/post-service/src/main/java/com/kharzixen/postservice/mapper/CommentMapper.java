package com.kharzixen.postservice.mapper;

import com.kharzixen.postservice.dto.outgoing.CommentDtoOut;
import com.kharzixen.postservice.model.Comment;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

@Mapper(componentModel = "spring")
public interface CommentMapper {
    CommentMapper INSTANCE = Mappers.getMapper(CommentMapper.class);

    @Mapping(target="owner.userId", source = "owner.id")
    CommentDtoOut modelToDto(Comment comment);
}
