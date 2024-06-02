package com.kharzixen.publicalbumservice.dto.outgoing.memoryDto;


import com.kharzixen.publicalbumservice.dto.outgoing.UserDtoOut;
import com.kharzixen.publicalbumservice.dto.outgoing.albumDto.AlbumSimplifiedDtoOut;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DetailedMemoryDtoOut {
    private Long id;
    private String caption;
    private String imageId;
    private UserDtoOut uploader;
    private AlbumSimplifiedDtoOut album;
    private Date creationDate;
    private int likeCount;
}
