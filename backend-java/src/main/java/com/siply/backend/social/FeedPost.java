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
@Table(name = "feed_posts")
public class FeedPost {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "drink_id")
    private Drink drink;

    private String content;
    @Column(name = "image_url")
    private String imageUrl;
    @Column(name = "likes_count")
    private Integer likesCount;
    @Column(name = "comments_count")
    private Integer commentsCount;
    @Column(name = "is_tagged")
    private Boolean isTagged;
    @Column(name = "tagged_users", columnDefinition = "uuid[]")
    private UUID[] taggedUsers;
    @Column(name = "created_at", insertable = false, updatable = false)
    private Instant createdAt;
}


