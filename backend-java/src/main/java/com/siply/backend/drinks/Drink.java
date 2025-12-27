package com.siply.backend.drinks;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.siply.backend.users.User;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "drinks")
public class Drink {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    @JsonIgnore
    private User user;

    @Column(nullable = false, length = 255)
    private String name;

    @Column(nullable = false, length = 50)
    private String category;

    private BigDecimal rating;
    private BigDecimal price;
    private String notes;

    @Column(name = "location_name")
    private String locationName;
    @Column(name = "location_city")
    private String locationCity;
    @Column(name = "location_country")
    private String locationCountry;

    @Column(precision = 10, scale = 8)
    private BigDecimal latitude;
    @Column(precision = 11, scale = 8)
    private BigDecimal longitude;

    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "tags", columnDefinition = "text[]")
    private String[] tags;

    @Column(name = "is_favorite")
    private Boolean isFavorite;

    @Column(name = "likes_count")
    private Integer likesCount;
    @Column(name = "comments_count")
    private Integer commentsCount;

    @Column(name = "created_at", insertable = false, updatable = false)
    private Instant createdAt;
    @Column(name = "updated_at", insertable = false)
    private Instant updatedAt;
}


