package com.kharzixen.albumservice.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "app_user")
public class User {

    @Id
    private Long id;
    private String username;
    private String pfpId;

    @OneToMany(mappedBy = "owner", cascade = CascadeType.ALL, orphanRemoval = false)
    private List<Album> ownedAlbums;

    @ManyToMany( mappedBy = "contributors" )
    private List<Album> albums;

    @OneToMany( mappedBy = "uploader",  orphanRemoval = false)
    private List<Memory> memories;

    @OneToMany(cascade = CascadeType.MERGE, mappedBy = "creator", orphanRemoval = false)
    private List<MemoryCollection> createdCollections;
}
