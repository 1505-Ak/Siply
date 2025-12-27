package com.siply.backend.auth.dto;

import lombok.Builder;

import java.util.UUID;

@Builder
public record UserResponse(
        UUID id,
        String username,
        String email,
        String displayName,
        String bio,
        String avatarUrl,
        String favoriteDrink,
        Integer followersCount,
        Integer followingCount,
        Integer totalDrinks,
        Integer totalCities,
        Integer totalCountries
) { }


