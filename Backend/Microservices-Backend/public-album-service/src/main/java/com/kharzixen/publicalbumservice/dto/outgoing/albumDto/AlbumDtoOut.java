package com.kharzixen.publicalbumservice.dto.outgoing.albumDto;


import com.kharzixen.publicalbumservice.dto.outgoing.UserDtoOut;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

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


}
