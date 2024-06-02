package com.kharzixen.publicalbumservice.dto.incomming;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AlbumDtoIn {
    private Long ownerId;
    private String albumName;
    private String caption;
    private MultipartFile image;
    private List<Long> invitedUserIds;
}
