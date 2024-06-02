package com.kharzixen.publicalbumservice.mapper;


import com.kharzixen.publicalbumservice.dto.incomming.MemoryDtoIn;
import com.kharzixen.publicalbumservice.dto.outgoing.memoryDto.DetailedMemoryDtoOut;
import com.kharzixen.publicalbumservice.dto.outgoing.memoryDto.MemoryPreviewDtoOut;
import com.kharzixen.publicalbumservice.dto.outgoing.memoryDto.SimpleMemoryDtoOut;
import com.kharzixen.publicalbumservice.model.Memory;
import com.kharzixen.publicalbumservice.projection.MemoryProjection;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

@Mapper(componentModel = "spring")
public interface MemoryMapper {
    MemoryMapper INSTANCE = Mappers.getMapper(MemoryMapper.class);


    @Mapping(target = "imageId", ignore = true )
    Memory dtoToModel(MemoryDtoIn memoryDtoIn);

    MemoryPreviewDtoOut modelToPreviewDto(Memory memory);

    MemoryPreviewDtoOut projectionToPreviewDto(MemoryProjection memoryProjection);

    DetailedMemoryDtoOut modelToDetailedDto(Memory memory);

    SimpleMemoryDtoOut modelToSimpleDto(Memory memory);

}
