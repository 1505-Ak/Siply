package com.siply.backend.social;

import com.siply.backend.drinks.Drink;
import com.siply.backend.users.User;
import jakarta.persistence.*;
import lombok.*;

import java.time.Instant;
import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "comments")
public class Comment {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "drink_id", nullable = false)
    private Drink drink;

    @Column(nullable = false)
    private String content;

    @Column(name = "created_at", insertable = false, updatable = false)
    private Instant createdAt;
    @Column(name = "updated_at", insertable = false)
    private Instant updatedAt;
}


