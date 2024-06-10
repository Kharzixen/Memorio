package com.kharzixen.albumservice.dto.outgoing.albumDto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DisposableCameraDtoOut {
    private Long id;

    private Boolean isActive;

    private Date closeTime;

    private String description;

}
