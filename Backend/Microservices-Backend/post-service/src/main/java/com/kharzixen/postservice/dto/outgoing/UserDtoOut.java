package com.kharzixen.postservice.dto.outgoing;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserDtoOut {
    private Long userId;
    private String username;
    private String pfpId;
    private boolean isDeleted;
}
