package com.kharzixen.albumservice.mapper;

import com.kharzixen.albumservice.dto.incomming.AlbumDtoIn;
import com.kharzixen.albumservice.dto.outgoing.albumDto.AlbumDtoOut;
import com.kharzixen.albumservice.dto.outgoing.albumDto.AlbumPreviewDto;
import com.kharzixen.albumservice.dto.outgoing.albumDto.AlbumSimplifiedDtoOut;
import com.kharzixen.albumservice.model.Album;
import com.kharzixen.albumservice.projection.AlbumPreviewProjection;
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

    List<AlbumDtoOut> modelsToDtos(List<Album> albums);

    @AfterMapping
    default void assignDefaultValues(AlbumDtoIn source, @MappingTarget Album.AlbumBuilder target) {
        target
                .collections(new ArrayList<>())
                .contributors(new ArrayList<>());
    }
}
