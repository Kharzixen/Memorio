package com.kharzixen.publicalbumservice.model;

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
    @Column(name = "image_id")
    private String imageId;

    private Boolean isHighlighted;

    private Date creationDate;

    @ManyToOne(cascade = CascadeType.PERSIST)
    @JoinColumn(name = "uploader_id")
    private User uploader;

    @ManyToOne(cascade = CascadeType.PERSIST)
    @JoinColumn(name = "album_id")
    private Album album;

    @OneToMany(cascade= CascadeType.PERSIST,mappedBy = "memory", orphanRemoval = true)
    private List<Like> likes;

    @OneToMany(cascade= CascadeType.PERSIST,mappedBy = "memory", orphanRemoval = true)
    private List<Comment> comments;
}
