package com.kharzixen.albumservice.dto.outgoing.albumDto;

import com.kharzixen.albumservice.dto.outgoing.UserDtoOut;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AlbumSimplifiedDtoOut {
    private Long id;

    private String albumName;

    private DisposableCameraDtoOut disposableCamera;

    private UserDtoOut owner;

    private String albumImageLink;
}
