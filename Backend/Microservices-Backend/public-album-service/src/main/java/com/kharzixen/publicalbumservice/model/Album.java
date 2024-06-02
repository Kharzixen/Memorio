package com.kharzixen.publicalbumservice.model;

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
public class Album {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "album_id")
    private Long id;

    private String albumName;

    @ManyToOne
    @JoinColumn(name = "owner_id")
    private User owner;

    private String caption;

    private String albumImageLink;

    private int contributorCount;

    @ManyToMany(cascade = CascadeType.PERSIST)
    @JoinTable(name = "album_contributor",  joinColumns  = @JoinColumn(name = "album_id")  , inverseJoinColumns = @JoinColumn(name = "user_id"))
    private List<User> contributors;

    @OneToMany(cascade = CascadeType.PERSIST, mappedBy = "album", orphanRemoval = true)
    private List<Memory> memories;

}
