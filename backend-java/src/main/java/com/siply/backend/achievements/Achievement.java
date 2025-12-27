package com.siply.backend.achievements;

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
@Table(name = "achievements")
public class Achievement {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @Column(nullable = false, unique = true, length = 50)
    private String code;

    @Column(nullable = false, length = 255)
    private String name;

    private String description;
    private String icon;
    @Column(name = "requirement_type")
    private String requirementType;
    @Column(name = "requirement_value")
    private Integer requirementValue;
    @Column(name = "created_at", insertable = false, updatable = false)
    private Instant createdAt;
}


