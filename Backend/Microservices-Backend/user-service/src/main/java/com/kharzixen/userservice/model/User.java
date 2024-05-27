package com.kharzixen.userservice.model;

import jakarta.persistence.*;
import lombok.*;
import java.util.Date;
import java.util.List;
import java.util.Set;


@Entity
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Setter
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique=true)
    private String username;

    @Column(unique=true)
    private String email;

    private Date birthday;

    private String name;
    private String bio;

    private String pfpId;

    private Date accountCreationDate;


    @ManyToMany
    @JoinTable(
            name = "user_followers",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "follower_id")
    )
    private Set<User> followers;
    private int followersCount;

    @ManyToMany(mappedBy = "followers", cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    private Set<User> following;
    private int followingCount;
}
