package com.kharzixen.publicalbumservice.dto.outgoing;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

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
