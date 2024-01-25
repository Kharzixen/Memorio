package com.kharzixen.userrelationshipservice.dto.incomming;

import com.kharzixen.userrelationshipservice.model.User;
import jakarta.annotation.sql.DataSourceDefinitions;
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
public class UserDtoIn {
    private String userId;
    private String username;
    private String pfpLink;
}
