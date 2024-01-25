package com.kharzixen.userrelationshipservice.dto.outgoing;

import com.kharzixen.userrelationshipservice.model.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.HashSet;
import java.util.Set;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserDtoOut {
    private String userId;
    private String username;
    private String pfpLink;
    private int followersCount;
    private int followingCount;

    private Set<UserDtoOutSimplified> followers = new HashSet<>();
    private Set<UserDtoOutSimplified> following = new HashSet<>();
}
