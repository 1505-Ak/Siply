package com.siply.backend.users;

import com.siply.backend.drinks.DrinkRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final DrinkRepository drinkRepository;

    public User getByUsername(String username) {
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
    }

    public List<User> search(String query) {
        if (query == null || query.isBlank()) {
            return List.of();
        }
        return userRepository.findAll().stream()
                .filter(u -> u.getUsername().toLowerCase().contains(query.toLowerCase()))
                .toList();
    }

    @Transactional
    public User updateProfile(User me, UserUpdateRequest request) {
        if (request.displayName() != null) me.setDisplayName(request.displayName());
        if (request.bio() != null) me.setBio(request.bio());
        if (request.avatarUrl() != null) me.setAvatarUrl(request.avatarUrl());
        if (request.favoriteDrink() != null) me.setFavoriteDrink(request.favoriteDrink());
        return userRepository.save(me);
    }

    public UserStats stats(String username) {
        User user = getByUsername(username);
        long drinkCount = drinkRepository.countByUser(user);
        return new UserStats(user.getFollowersCount(), user.getFollowingCount(), drinkCount);
    }

    public record UserStats(Integer followers, Integer following, Long drinks) {}
}


