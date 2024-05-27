package com.kharzixen.albumservice.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DisposableCameraMemory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String caption;
    @Column(name = "image_id")
    private String imageId;

    private Date creationDate;

    @ManyToOne(cascade = CascadeType.PERSIST)
    @JoinColumn(name = "uploader_id")
    private User uploader;

    @ManyToOne(cascade = CascadeType.PERSIST)
    @JoinColumn(name = "disposable_camera_id")
    private DisposableCamera disposableCamera;
}
