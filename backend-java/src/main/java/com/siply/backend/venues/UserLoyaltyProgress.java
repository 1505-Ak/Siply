package com.siply.backend.venues;

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
@Table(name = "user_loyalty_progress")
public class UserLoyaltyProgress {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "venue_id")
    private Venue venue;

    @Column(name = "points_earned")
    private Integer pointsEarned;
    @Column(name = "visit_count")
    private Integer visitCount;
    @Column(name = "is_favorite")
    private Boolean isFavorite;
    @Column(name = "last_visit")
    private Instant lastVisit;
    @Column(name = "created_at", insertable = false, updatable = false)
    private Instant createdAt;
    @Column(name = "updated_at", insertable = false)
    private Instant updatedAt;
}


