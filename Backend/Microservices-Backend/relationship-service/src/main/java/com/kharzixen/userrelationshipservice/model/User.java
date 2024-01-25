package com.kharzixen.userrelationshipservice.model;

import lombok.*;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;
import org.springframework.data.neo4j.core.schema.Relationship;
import org.springframework.stereotype.Indexed;

import java.util.HashSet;
import java.util.Set;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@Node
public class User {

    //data from user service;
    @Id
    private String userId;
    private String username;
    private String pfpLink;

    private int followersCount;
    private int followingCount;

    //relationships;
    @Relationship(type = "FOLLOWS", direction = Relationship.Direction.INCOMING)
    private Set<User> followers = new HashSet<>();

    @Relationship(type = "FOLLOWS", direction = Relationship.Direction.OUTGOING)
    private Set<User> following = new HashSet<>();
}
