package com.kharzixen.albumservice.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Collection;
import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Album {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "albumId")
    private Long id;

    private String albumName;

    @ManyToOne
    @JoinColumn(name = "owner_id")
    private User owner;

    private String caption;

    private String albumImageLink;

    private int contributorCount;

    @ManyToMany(cascade = CascadeType.ALL)
    @JoinTable(name = "album_contributor",  joinColumns  = @JoinColumn(name = "album_id")  , inverseJoinColumns = @JoinColumn(name = "user_id"))
    private List<User> contributors;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "album", orphanRemoval = true)
    private List<Memory> memories;

    @OneToMany(cascade =  CascadeType.MERGE, mappedBy = "album", orphanRemoval = true)
    private List<MemoryCollection> collections;
}
