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
public class DisposableCamera {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Boolean isActive;

    private String description;

    @OneToOne(mappedBy = "disposableCamera")
    private Album album;

    @OneToMany(cascade = CascadeType.PERSIST, mappedBy = "disposableCamera", orphanRemoval = true)
    private List<DisposableCameraMemory> memories;

}
