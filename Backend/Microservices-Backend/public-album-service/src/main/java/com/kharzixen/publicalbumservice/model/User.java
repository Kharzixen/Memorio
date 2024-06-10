package com.kharzixen.publicalbumservice.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.Objects;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "app_user")
public class User {

    @Id
    private Long id;
    private String username;
    private Boolean isDeleted;
    private Boolean isAdmin;
    private Boolean isActive;

    @OneToMany(mappedBy = "owner", cascade = CascadeType.PERSIST, orphanRemoval = false)
    private List<Album> ownedAlbums;

    @ManyToMany(mappedBy = "contributors")
    private List<Album> albums;

    @OneToMany(mappedBy = "uploader", orphanRemoval = false)
    private List<Memory> memories;


    @OneToMany(mappedBy = "user", orphanRemoval = true)
    private List<Like> likes;

    @OneToMany(mappedBy = "owner", orphanRemoval = true)
    private List<Comment> comments;

    // Override hashCode
    @Override
    public int hashCode() {
        return Objects.hashCode(id);
    }

    // Override equals
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User user = (User) o;
        return Objects.equals(id, user.id);
    }
}
