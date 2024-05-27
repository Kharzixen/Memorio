package com.kharzixen.albumservice.mapper;

import com.kharzixen.albumservice.dto.outgoing.CommentDtoOut;
import com.kharzixen.albumservice.model.Comment;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

@Mapper(componentModel = "spring")
public interface CommentMapper {
    CommentMapper INSTANCE = Mappers.getMapper(CommentMapper.class);

    CommentDtoOut modelToDto(Comment comment);
}
