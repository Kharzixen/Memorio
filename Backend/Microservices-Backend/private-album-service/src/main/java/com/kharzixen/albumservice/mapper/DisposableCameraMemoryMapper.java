package com.kharzixen.albumservice.mapper;


import com.kharzixen.albumservice.dto.incomming.DisposableCameraMemoryDtoIn;
import com.kharzixen.albumservice.dto.outgoing.disposableCameraMemoryDto.DisposableCameraMemoryDtoOut;
import com.kharzixen.albumservice.model.DisposableCameraMemory;
import com.kharzixen.albumservice.projection.DisposableCameraMemoryProjection;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

@Mapper(componentModel = "spring")
public interface DisposableCameraMemoryMapper {
    DisposableCameraMemoryMapper INSTANCE = Mappers.getMapper(DisposableCameraMemoryMapper.class);


    @Mapping(target = "imageId", ignore = true )
    DisposableCameraMemory dtoToModel(DisposableCameraMemoryDtoIn memoryDtoIn);

    DisposableCameraMemoryDtoOut modelToDto(DisposableCameraMemory memory);

    DisposableCameraMemoryDtoOut projectionToPreviewDto(DisposableCameraMemoryProjection memoryProjection);

}
