package com.kharzixen.albumservice.dto.outgoing.albumDto;


import com.kharzixen.albumservice.dto.outgoing.UserDtoOut;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AlbumDtoOut {
    private Long id;

    private UserDtoOut owner;

    private String albumName;

    private int contributorCount;

    private String caption;

    private String albumImageLink;

    private List<UserDtoOut> contributorsPreview;

}
