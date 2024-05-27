package com.kharzixen.albumservice.mapper;

import com.kharzixen.albumservice.dto.outgoing.albumDto.AlbumDtoOut;
import com.kharzixen.albumservice.dto.outgoing.albumDto.DisposableCameraDtoOut;
import com.kharzixen.albumservice.model.Album;
import com.kharzixen.albumservice.model.DisposableCamera;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

@Mapper(componentModel = "spring")
public interface DisposableCameraMapper  {
    DisposableCameraMapper INSTANCE = Mappers.getMapper(DisposableCameraMapper.class);

    @Mapping(source = "isActive", target = "isActive")
    DisposableCameraDtoOut modelToDto(DisposableCamera camera);
}
