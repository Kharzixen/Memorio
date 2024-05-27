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

    @ManyToOne(cascade = CascadeType.PERSIST)
    private User creator;

    @ManyToOne(cascade = CascadeType.PERSIST)
    @JoinColumn(name = "album_id")
    private Album album;

    @OneToMany(cascade= CascadeType.PERSIST,mappedBy = "collection")
    private List<MemoryCollectionRelationship> memories;

    private Date creationDate;

}
