package com.kharzixen.userservice.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "user_outbox_table")
public class UserEventOutbox {
    // this table is for implementing the outbox pattern for microservices async communication
    // in a single transaction, we save an event to this table when the server changes a user
    // and the events are going to be consumed from this table

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String eventType;

    private Long userId;

    private String username;

    private String pfpId;

}
