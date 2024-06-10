package com.kharzixen.authenticationservice.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class RegistrationDtoIn {
    private String username;
    private String password;
    private String confirmPassword;
    private String email;
    private String phoneNumber;
    //---------------------------
    private Date birthday;
    private String name;
}
