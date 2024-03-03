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

    @OneToMany(mappedBy = "owner", cascade = CascadeType.ALL, orphanRemoval = false)
    private List<Album> ownedAlbums;

    @ManyToMany(cascade = CascadeType.ALL)
    @JoinTable(name = "user_album",  joinColumns  = @JoinColumn(name = "album_id")  , inverseJoinColumns = @JoinColumn(name = "user_id"))
    private List<Album> albums;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "uploader",  orphanRemoval = false)
    private List<Memory> memories;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "creator", orphanRemoval = false)
    private List<MemoryCollection> createdCollections;
}
