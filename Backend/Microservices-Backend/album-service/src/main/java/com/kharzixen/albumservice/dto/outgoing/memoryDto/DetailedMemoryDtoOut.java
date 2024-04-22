package com.kharzixen.albumservice.dto.outgoing.memoryDto;

import com.kharzixen.albumservice.dto.outgoing.albumDto.AlbumSimplifiedDtoOut;
import com.kharzixen.albumservice.dto.outgoing.collectionDto.MemoryCollectionDtoOut;
import com.kharzixen.albumservice.dto.outgoing.UserDtoOut;
import com.kharzixen.albumservice.dto.outgoing.collectionDto.MemoryCollectionSimplifiedDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DetailedMemoryDtoOut {
    private Long id;
    private String caption;
    private String imageLink;
    private UserDtoOut uploader;
    private AlbumSimplifiedDtoOut album;
    List<MemoryCollectionSimplifiedDto> collections;
    private Date creationDate;
}
