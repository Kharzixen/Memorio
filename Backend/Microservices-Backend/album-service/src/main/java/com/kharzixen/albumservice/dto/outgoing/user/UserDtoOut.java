package com.kharzixen.albumservice.dto.outgoing.user;

import com.kharzixen.albumservice.model.Album;
import com.kharzixen.albumservice.model.Memory;
import com.kharzixen.albumservice.model.MemoryCollection;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserDtoOut {
    private Long id;
    private String username;

    private List<Album> ownedAlbums;

    private List<Album> albums;

    private List<Memory> memories;

    private List<MemoryCollection> createdCollections;
}
