package com.kharzixen.albumservice.mapper;

import com.kharzixen.albumservice.dto.incomming.MemoryCollectionDtoIn;
import com.kharzixen.albumservice.dto.outgoing.collectionDto.MemoryCollectionDtoOut;
import com.kharzixen.albumservice.dto.outgoing.collectionDto.MemoryCollectionPreviewDtoOut;
import com.kharzixen.albumservice.dto.outgoing.collectionDto.MemoryCollectionSimplifiedDto;
import com.kharzixen.albumservice.model.MemoryCollection;
import com.kharzixen.albumservice.projection.MemoryCollectionPreviewProjection;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;


import java.util.List;

@Mapper(componentModel = "spring")
public interface MemoryCollectionMapper {


    MemoryCollectionMapper INSTANCE = Mappers.getMapper(MemoryCollectionMapper.class);

    MemoryCollection dtoToModel(MemoryCollectionDtoIn dtoIn);

    MemoryCollectionDtoOut modelToDto(MemoryCollection memoryCollection);

    MemoryCollectionPreviewDtoOut projectionToDto(MemoryCollectionPreviewProjection projection);

    MemoryCollectionSimplifiedDto modelToSimplifiedDto(MemoryCollection memoryCollection);

    List<MemoryCollectionDtoOut> modelsToDtos(List<MemoryCollection> collections);


    MemoryCollectionPreviewDtoOut modelToPreviewDto(MemoryCollection collection);
}
