package com.kharzixen.publicalbumservice.mapper;


import com.kharzixen.publicalbumservice.dto.outgoing.CommentDtoOut;
import com.kharzixen.publicalbumservice.model.Comment;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

@Mapper(componentModel = "spring")
public interface CommentMapper {
    CommentMapper INSTANCE = Mappers.getMapper(CommentMapper.class);

    CommentDtoOut modelToDto(Comment comment);
}
