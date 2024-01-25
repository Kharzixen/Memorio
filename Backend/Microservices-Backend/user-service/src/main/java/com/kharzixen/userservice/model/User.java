package com.kharzixen.userservice.model;

import lombok.*;
import org.bson.codecs.pojo.annotations.BsonProperty;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.Set;

@Document
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Setter
public class User {

    @Id
    @BsonProperty("id")
    private String id;

    @Indexed(unique = true)
    @BsonProperty("username")
    private String username;

    @Indexed(unique = true)
    private String email;

    private Date birthday;

    private String name;
    private String bio;
    @BsonProperty("pfpLink")
    private String pfpLink;

    private Date accountCreationDate;
}
