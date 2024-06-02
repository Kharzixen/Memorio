package com.kharzixen.publicalbumservice.dto.outgoing.memoryDto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class SimpleMemoryDtoOut {
    Long id;
    String imageId;
    Date creationDate;
}
