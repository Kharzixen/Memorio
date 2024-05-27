package com.kharzixen.albumservice.dto.outgoing.collectionDto;


import com.kharzixen.albumservice.dto.outgoing.UserDtoOut;
import com.kharzixen.albumservice.dto.outgoing.albumDto.AlbumSimplifiedDtoOut;
import com.kharzixen.albumservice.dto.outgoing.memoryDto.MemoryPreviewDtoOut;
import com.kharzixen.albumservice.dto.outgoing.memoryDto.MemoryPreviewOfCollectionDtoOut;
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
public class MemoryCollectionPreviewDtoOut {
    private Long id;
    private String collectionName;
    private String collectionDescription;
    private UserDtoOut creator;
    private AlbumSimplifiedDtoOut album;
    private Date creationDate;
    private List<MemoryPreviewOfCollectionDtoOut> latestMemories;
}
