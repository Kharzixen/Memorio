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
@Table(name = "collection")
public class MemoryCollection {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String collectionName;

    @ManyToOne(cascade = CascadeType.ALL)
    private User creator;

    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "album_id")
    private Album album;

    @ManyToMany(cascade = CascadeType.ALL)
    @JoinTable(name = "collection_memory", joinColumns  =  @JoinColumn(name = "collection_id") , inverseJoinColumns =  @JoinColumn(name = "memory_id"))
    private List<Memory> memories;

}
