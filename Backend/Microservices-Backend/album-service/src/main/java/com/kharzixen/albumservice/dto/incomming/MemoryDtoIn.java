package com.kharzixen.albumservice.dto.incomming;

import com.kharzixen.albumservice.model.User;
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
public class MemoryDtoIn {
    private Long uploaderId;
    private Long albumId;
    private String caption;
    private MultipartFile image;
    List<Long> collectionIds;
}
