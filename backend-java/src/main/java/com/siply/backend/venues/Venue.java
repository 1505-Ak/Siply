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
@Table(name = "venues")
public class Venue {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @Column(nullable = false, length = 255)
    private String name;

    @Column(nullable = false, length = 50)
    private String category;

    private String address;
    private String city;
    private String country;
    private BigDecimal latitude;
    private BigDecimal longitude;
    @Column(name = "has_student_discount")
    private Boolean hasStudentDiscount;
    @Column(name = "has_happy_hour")
    private Boolean hasHappyHour;
    @Column(name = "is_partner")
    private Boolean isPartner;
    @Column(name = "image_url")
    private String imageUrl;
    private String phone;
    private String website;
    @Column(name = "opening_hours", columnDefinition = "jsonb")
    private String openingHours;

    @Column(name = "created_at", insertable = false, updatable = false)
    private Instant createdAt;
    @Column(name = "updated_at", insertable = false)
    private Instant updatedAt;
}


