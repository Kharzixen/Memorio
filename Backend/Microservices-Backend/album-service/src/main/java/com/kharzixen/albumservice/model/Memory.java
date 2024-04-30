package com.kharzixen.albumservice.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;
import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Memory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String caption;
    private String imageLink;

    private Date creationDate;

    @ManyToOne(cascade = CascadeType.PERSIST)
    @JoinColumn(name = "uploader_id")
    private User uploader;

    @ManyToOne(cascade = CascadeType.MERGE)
    @JoinColumn(name = "album_id")
    private Album album;

    @ManyToMany(cascade= CascadeType.PERSIST, fetch = FetchType.EAGER)
    @JoinTable(name = "memory_collection", joinColumns  =  @JoinColumn(name = "memory_id") , inverseJoinColumns =  @JoinColumn(name = "collection_id"))
    private List<MemoryCollection> collections;


    //TODO: likes + comments
}
