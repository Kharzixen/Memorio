package com.kharzixen.publicalbumservice.mapper;


import com.kharzixen.publicalbumservice.dto.incomming.AlbumDtoIn;
import com.kharzixen.publicalbumservice.dto.outgoing.albumDto.AlbumDtoOut;
import com.kharzixen.publicalbumservice.dto.outgoing.albumDto.AlbumPreviewDto;
import com.kharzixen.publicalbumservice.dto.outgoing.albumDto.AlbumSimplifiedDtoOut;
import com.kharzixen.publicalbumservice.model.Album;
import com.kharzixen.publicalbumservice.projection.AlbumPreviewProjection;
import org.mapstruct.AfterMapping;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.factory.Mappers;

import java.util.ArrayList;
import java.util.List;

@Mapper(componentModel = "spring")
public interface AlbumMapper {
    AlbumMapper INSTANCE = Mappers.getMapper(AlbumMapper.class);

    AlbumDtoOut modelToDto(Album album);

    AlbumSimplifiedDtoOut modelToSimplifiedDto(Album album);


    @Mapping(source = "caption", target = "caption")
    @Mapping(target = "albumImageLink", ignore = true)
    Album dtoToModel(AlbumDtoIn albumDtoIn);

    @Mapping(target = "recentMemories", ignore = true)
    AlbumPreviewDto projectionToDto(AlbumPreviewProjection projection);

    AlbumPreviewDto modelToPreviewDto(Album album);

    List<AlbumDtoOut> modelsToDtos(List<Album> albums);

}
