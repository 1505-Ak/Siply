package com.siply.backend.venues;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "loyalty_programs")
public class LoyaltyProgram {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "venue_id")
    private Venue venue;

    @Column(name = "program_type", nullable = false, length = 50)
    private String programType;
    @Column(name = "points_per_visit")
    private Integer pointsPerVisit;
    @Column(name = "points_per_dollar")
    private Integer pointsPerDollar;
    @Column(name = "has_multiplier")
    private Boolean hasMultiplier;
    @Column(name = "multiplier_rate")
    private BigDecimal multiplierRate;
    @Column(name = "has_subscription")
    private Boolean hasSubscription;
    @Column(name = "subscription_details")
    private String subscriptionDetails;
    @Column(name = "has_visit_card")
    private Boolean hasVisitCard;
    @Column(name = "visit_card_goal")
    private Integer visitCardGoal;
}


