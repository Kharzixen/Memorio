package com.kharzixen.albumservice.dto.incomming;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DisposableCameraMemoryDtoIn {
    private Long uploaderId;
    private Long albumId;
    private String caption;
    private MultipartFile image;
}
