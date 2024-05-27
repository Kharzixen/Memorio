package com.kharzixen.albumservice.dto.incomming;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MemoryCollectionDtoIn {
    private String collectionName;
    private String collectionDescription;
    private Long creatorId;
    private Long albumId;
}
