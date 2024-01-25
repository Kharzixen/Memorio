package com.kharzixen.userservice.dto.outgoing;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserSimplifiedDtoOut {
    private String userId;
    private String username;
    private String pfpLink;
}
