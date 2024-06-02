package com.kharzixen.publicalbumservice.model;

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
public class Comment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(cascade = CascadeType.PERSIST)
    @JoinColumn(name = "user_id")
    private User owner;

    @ManyToOne(cascade = CascadeType.PERSIST)
    @JoinColumn(name = "memory_id")
    private Memory memory;

    private String message;

    private Date dateWhenMade;
}
