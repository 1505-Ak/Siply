package com.siply.backend.users;

public record UserUpdateRequest(
        String displayName,
        String bio,
        String avatarUrl,
        String favoriteDrink
) { }


