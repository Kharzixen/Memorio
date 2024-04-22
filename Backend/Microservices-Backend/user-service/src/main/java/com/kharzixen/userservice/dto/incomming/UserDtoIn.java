package com.kharzixen.userservice.dto.incomming;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Past;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;


import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserDtoIn {

    @NotBlank(message = "Username is mandatory")
    @Size(max = 30, message = "Username cannot exceed 50 characters")
    private String username;

    @NotBlank(message = "Email is mandatory")
    private String email;

    @Past
    @NotNull(message = "AccountCreationDate is Mandatory")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date birthday;

    @NotBlank(message = "Name is mandatory")
    @Size(max = 50, message = "Name cannot exceed 50 characters")
    private String name;

    private MultipartFile profileImage;

    @Size(max = 200, message = "Bio cannot exceed 200 characters")
    private String bio;

}
