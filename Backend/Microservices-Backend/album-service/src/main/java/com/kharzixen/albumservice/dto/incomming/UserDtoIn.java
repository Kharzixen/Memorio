package com.kharzixen.albumservice.dto.incomming;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserDtoIn {
    private Long id;
    private String username;

    private String pfpId;
}
