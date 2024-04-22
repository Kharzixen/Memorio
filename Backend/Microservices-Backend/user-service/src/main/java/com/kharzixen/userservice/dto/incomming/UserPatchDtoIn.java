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

import java.time.LocalDate;
import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserPatchDtoIn {

    @Size(max = 30, message = "Username cannot exceed 50 characters")
    private String username;
    private String email;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date birthday;

    @Size(max = 50, message = "Name cannot exceed 50 characters")
    private String name;
    @Size(max = 200, message = "Bio cannot exceed 200 characters")
    private String bio;
    private String pfpId;
}
