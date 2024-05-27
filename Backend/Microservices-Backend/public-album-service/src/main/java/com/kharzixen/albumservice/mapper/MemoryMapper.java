package com.kharzixen.albumservice.mapper;

import com.kharzixen.albumservice.dto.incomming.MemoryDtoIn;
import com.kharzixen.albumservice.dto.outgoing.memoryDto.DetailedMemoryDtoOut;
import com.kharzixen.albumservice.dto.outgoing.memoryDto.MemoryPreviewDtoOut;
import com.kharzixen.albumservice.dto.outgoing.memoryDto.MemoryPreviewOfCollectionDtoOut;
import com.kharzixen.albumservice.model.Memory;
import com.kharzixen.albumservice.projection.MemoryProjection;
import org.mapstruct.*;
import org.mapstruct.factory.Mappers;

@Mapper(componentModel = "spring")
public interface MemoryMapper {
    MemoryMapper INSTANCE = Mappers.getMapper(MemoryMapper.class);


    @Mapping(target = "imageId", ignore = true )
    Memory dtoToModel(MemoryDtoIn memoryDtoIn);

    MemoryPreviewDtoOut modelToPreviewDto(Memory memory);

    MemoryPreviewDtoOut projectionToPreviewDto(MemoryProjection memoryProjection);

    DetailedMemoryDtoOut modelToDetailedDto(Memory memory);

}
