package com.siply.backend.drinks;

import com.siply.backend.drinks.dto.DrinkRequest;
import com.siply.backend.drinks.dto.DrinkResponse;
import com.siply.backend.users.User;
import com.siply.backend.social.FeedPostRepository;
import com.siply.backend.social.FeedPost;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class DrinkService {

    private final DrinkRepository drinkRepository;
    private final FeedPostRepository feedPostRepository;

    public List<DrinkResponse> listAll() {
        return drinkRepository.findAll().stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    public DrinkResponse get(UUID id) {
        return drinkRepository.findById(id)
                .map(this::toResponse)
                .orElseThrow(() -> new RuntimeException("Drink not found"));
    }

    public List<DrinkResponse> listForUser(User user) {
        return drinkRepository.findByUser(user).stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    @Transactional
    public DrinkResponse create(User user, DrinkRequest request) {
        Drink drink = Drink.builder()
                .user(user)
                .name(request.name())
                .category(request.category())
                .rating(request.rating())
                .price(request.price())
                .notes(request.notes())
                .locationName(request.locationName())
                .locationCity(request.locationCity())
                .locationCountry(request.locationCountry())
                .latitude(request.latitude())
                .longitude(request.longitude())
                .imageUrl(request.imageUrl())
                .tags(request.tags() != null ? request.tags().toArray(new String[0]) : null)
                .isFavorite(request.isFavorite())
                .likesCount(0)
                .commentsCount(0)
                .build();

        Drink saved = drinkRepository.save(drink);
        feedPostRepository.save(
                FeedPost.builder()
                        .user(user)
                        .drink(saved)
                        .content(request.notes())
                        .imageUrl(request.imageUrl())
                        .likesCount(0)
                        .commentsCount(0)
                        .isTagged(false)
                        .build()
        );
        return toResponse(saved);
    }

    @Transactional
    public DrinkResponse update(UUID id, User user, DrinkRequest request) {
        Drink drink = drinkRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Drink not found"));
        if (!drink.getUser().getId().equals(user.getId())) {
            throw new RuntimeException("Forbidden");
        }
        drink.setName(request.name());
        drink.setCategory(request.category());
        drink.setRating(request.rating());
        drink.setPrice(request.price());
        drink.setNotes(request.notes());
        drink.setLocationName(request.locationName());
        drink.setLocationCity(request.locationCity());
        drink.setLocationCountry(request.locationCountry());
        drink.setLatitude(request.latitude());
        drink.setLongitude(request.longitude());
        drink.setImageUrl(request.imageUrl());
        drink.setTags(request.tags() != null ? request.tags().toArray(new String[0]) : null);
        drink.setIsFavorite(request.isFavorite());
        return toResponse(drinkRepository.save(drink));
    }

    @Transactional
    public void delete(UUID id, User user) {
        Drink drink = drinkRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Drink not found"));
        if (!drink.getUser().getId().equals(user.getId())) {
            throw new RuntimeException("Forbidden");
        }
        drinkRepository.delete(drink);
    }

    public List<DrinkResponse> trendingAll() {
        return drinkRepository.findAllByOrderByLikesCountDesc().stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    private DrinkResponse toResponse(Drink drink) {
        return DrinkResponse.builder()
                .id(drink.getId())
                .userId(drink.getUser() != null ? drink.getUser().getId() : null)
                .name(drink.getName())
                .category(drink.getCategory())
                .rating(drink.getRating())
                .price(drink.getPrice())
                .notes(drink.getNotes())
                .locationName(drink.getLocationName())
                .locationCity(drink.getLocationCity())
                .locationCountry(drink.getLocationCountry())
                .latitude(drink.getLatitude())
                .longitude(drink.getLongitude())
                .imageUrl(drink.getImageUrl())
                .tags(drink.getTags())
                .isFavorite(drink.getIsFavorite())
                .likesCount(drink.getLikesCount())
                .commentsCount(drink.getCommentsCount())
                .createdAt(drink.getCreatedAt())
                .updatedAt(drink.getUpdatedAt())
                .build();
    }
}


