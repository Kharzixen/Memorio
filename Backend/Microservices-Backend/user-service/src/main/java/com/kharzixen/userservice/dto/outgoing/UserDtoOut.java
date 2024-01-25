package com.kharzixen.userservice.dto.outgoing;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;
import java.util.LinkedHashSet;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserDtoOut {

    private String userId;
    private String username;
    private String email;

    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "EET")
    private Date birthday;

    private String name;
    private String bio;
    private String pfpLink;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm", timezone = "EET")
    private Date accountCreationDate;

}
