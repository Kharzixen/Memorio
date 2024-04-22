package com.kharzixen.albumservice.dto.outgoing.collectionDto;

import com.kharzixen.albumservice.dto.outgoing.UserDtoOut;
import com.kharzixen.albumservice.dto.outgoing.albumDto.AlbumDtoOut;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MemoryCollectionDtoOut {

    private Long id;

    private String collectionName;

    private String collectionDescription;

    private UserDtoOut creator;

    private AlbumDtoOut album;
}
