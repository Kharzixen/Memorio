package com.kharzixen.albumservice.mapper;

import com.kharzixen.albumservice.dto.incomming.AlbumDtoIn;
import com.kharzixen.albumservice.dto.outgoing.album.AlbumDtoOut;
import com.kharzixen.albumservice.model.Album;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AlbumMapper {
    AlbumMapper INSTANCE = Mappers.getMapper(AlbumMapper.class);

    AlbumDtoOut modelToDto(Album album);


    @Mapping(source = "caption", target = "caption")
    @Mapping(source = "albumImageLink", target = "albumImageLink")
    Album dtoToModel(AlbumDtoIn albumDtoIn);

    List<AlbumDtoOut> modelsToDtos(List<Album> albums);
}
