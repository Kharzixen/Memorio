package com.kharzixen.albumservice.dto.outgoing.collectionDto;

import com.kharzixen.albumservice.dto.outgoing.albumDto.AlbumSimplifiedDtoOut;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MemoryCollectionSimplifiedDto {
    private Long id;
    private String collectionName;
    private AlbumSimplifiedDtoOut album;
}
