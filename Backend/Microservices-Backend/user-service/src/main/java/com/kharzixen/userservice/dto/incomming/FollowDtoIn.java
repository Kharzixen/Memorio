package com.kharzixen.userservice.dto.incomming;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class FollowDtoIn {
    private Long fromId;
    private Long toId;
}
