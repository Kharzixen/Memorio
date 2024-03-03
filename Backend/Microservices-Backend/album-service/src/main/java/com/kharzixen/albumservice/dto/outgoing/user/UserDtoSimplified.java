package com.kharzixen.albumservice.dto.outgoing.user;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserDtoSimplified {
    private Long id;
    private String username;
}
