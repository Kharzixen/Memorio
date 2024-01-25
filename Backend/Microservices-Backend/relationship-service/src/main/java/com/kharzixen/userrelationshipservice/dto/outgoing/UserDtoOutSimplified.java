package com.kharzixen.userrelationshipservice.dto.outgoing;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserDtoOutSimplified {
    //only node data, without relationships, no infinite serialization overflow
    private String userId;
    private String username;
    private String pfpLink;
}
