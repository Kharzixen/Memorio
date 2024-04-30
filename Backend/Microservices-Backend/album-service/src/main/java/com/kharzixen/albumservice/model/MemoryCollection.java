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
@Table(name = "collection", uniqueConstraints = @UniqueConstraint(columnNames = {"collection_name", "album_id"}))
public class MemoryCollection {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "collection_name")
    private String collectionName;

    private String collectionDescription;

    @ManyToOne(cascade = CascadeType.MERGE)
    private User creator;

    @ManyToOne(cascade = CascadeType.MERGE)
    @JoinColumn(name = "album_id")
    private Album album;

    @ManyToMany(cascade= CascadeType.PERSIST, fetch = FetchType.LAZY, mappedBy = "collections")
    private List<Memory> memories;

    private Date creationDate;

}
