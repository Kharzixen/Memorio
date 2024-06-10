package com.kharzixen.albumservice.dto.incomming;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DisposableCameraPatchDtoIn {
    private String description;
    private Date closeTime;
    private Boolean isActive;
}
