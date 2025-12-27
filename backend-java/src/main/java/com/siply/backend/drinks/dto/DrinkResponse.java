package com.siply.backend.drinks.dto;

import lombok.Builder;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Builder
public record DrinkResponse(
        UUID id,
        UUID userId,
        String name,
        String category,
        BigDecimal rating,
        BigDecimal price,
        String notes,
        String locationName,
        String locationCity,
        String locationCountry,
        BigDecimal latitude,
        BigDecimal longitude,
        String imageUrl,
        String[] tags,
        Boolean isFavorite,
        Integer likesCount,
        Integer commentsCount,
        Instant createdAt,
        Instant updatedAt
) { }


