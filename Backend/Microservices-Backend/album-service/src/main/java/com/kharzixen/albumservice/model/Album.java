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

    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "owner_id")
    private User owner;

    private String caption;

    private String albumImageLink;

    @ManyToMany(cascade = CascadeType.ALL)
    @JoinTable(name = "user_album",  joinColumns  =  @JoinColumn(name = "user_id") , inverseJoinColumns =  @JoinColumn(name = "album_id"))
    private List<User> contributors;

    @OneToOne
    @JoinColumn(name = "base_collection_id")
    private MemoryCollection baseCollection;

    @OneToMany(cascade =  CascadeType.ALL, mappedBy = "album", orphanRemoval = true)
    private List<MemoryCollection> collections;
}
