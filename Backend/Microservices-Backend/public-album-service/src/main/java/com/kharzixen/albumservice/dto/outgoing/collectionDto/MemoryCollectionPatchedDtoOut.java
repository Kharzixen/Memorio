package com.kharzixen.albumservice.dto.outgoing.collectionDto;


import com.kharzixen.albumservice.dto.outgoing.memoryDto.MemoryPreviewDtoOut;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MemoryCollectionPatchedDtoOut {

    private String method;

    private Long id;

    private List<MemoryPreviewDtoOut> changedMemories;
}
