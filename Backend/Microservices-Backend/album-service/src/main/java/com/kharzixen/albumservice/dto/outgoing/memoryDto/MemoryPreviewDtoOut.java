package com.kharzixen.albumservice.dto.outgoing.memoryDto;

import com.kharzixen.albumservice.dto.outgoing.UserDtoOut;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MemoryPreviewDtoOut {
    Long id;
    UserDtoOut uploader;
    String caption;
    String imageLink;
    Date creationDate;
}
