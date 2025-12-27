package com.siply.backend.drinks.dto;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;
import java.util.List;

public record DrinkRequest(
        @NotBlank @Size(max = 255) String name,
        @NotBlank @Size(max = 50) String category,
        @DecimalMin("0.0") @DecimalMax("5.0") BigDecimal rating,
        BigDecimal price,
        String notes,
        String locationName,
        String locationCity,
        String locationCountry,
        BigDecimal latitude,
        BigDecimal longitude,
        String imageUrl,
        List<String> tags,
        Boolean isFavorite
) { }


