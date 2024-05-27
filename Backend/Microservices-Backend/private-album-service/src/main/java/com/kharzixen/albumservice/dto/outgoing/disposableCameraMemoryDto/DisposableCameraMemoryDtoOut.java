package com.kharzixen.albumservice.dto.outgoing.disposableCameraMemoryDto;

import com.kharzixen.albumservice.dto.outgoing.UserDtoOut;
import com.kharzixen.albumservice.dto.outgoing.albumDto.DisposableCameraDtoOut;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DisposableCameraMemoryDtoOut {
    private Long id;
    private String caption;
    private String imageId;
    private UserDtoOut uploader;
    private DisposableCameraDtoOut disposableCamera;
    private Date creationDate;
}
