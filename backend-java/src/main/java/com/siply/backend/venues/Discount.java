package com.siply.backend.venues;

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
@Table(name = "discounts")
public class Discount {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "venue_id")
    private Venue venue;

    @Column(nullable = false, length = 255)
    private String title;

    private String description;
    @Column(name = "discount_percentage")
    private Integer discountPercentage;
    @Column(name = "discount_amount")
    private BigDecimal discountAmount;
    @Column(name = "requires_student_id")
    private Boolean requiresStudentId;
    @Column(name = "valid_from")
    private Instant validFrom;
    @Column(name = "valid_until")
    private Instant validUntil;
    private String terms;
    @Column(name = "is_active")
    private Boolean isActive;
    @Column(name = "created_at", insertable = false, updatable = false)
    private Instant createdAt;
}


