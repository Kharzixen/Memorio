package com.kharzixen.albumservice.dto.outgoing;

import com.kharzixen.albumservice.dto.outgoing.albumDto.AlbumSimplifiedDtoOut;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.Map;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserAlbumsPatchedDtoOut {
    private String method;
    private String userId;
    private Map<Long, String> changeLog;
}
