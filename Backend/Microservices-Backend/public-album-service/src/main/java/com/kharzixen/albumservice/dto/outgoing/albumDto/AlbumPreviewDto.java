package com.kharzixen.albumservice.dto.outgoing.albumDto;

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
public class AlbumPreviewDto {
    private Long id;

    private String albumName;

    private String caption;

    private String albumImageLink;

    //  4 image
    List<MemoryPreviewDtoOut> recentMemories;
}
