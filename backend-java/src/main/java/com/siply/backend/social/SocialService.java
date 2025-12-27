package com.siply.backend.social;

import com.siply.backend.drinks.Drink;
import com.siply.backend.drinks.DrinkRepository;
import com.siply.backend.users.User;
import com.siply.backend.users.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class SocialService {

    private final FollowRepository followRepository;
    private final LikeRepository likeRepository;
    private final CommentRepository commentRepository;
    private final FeedPostRepository feedPostRepository;
    private final UserRepository userRepository;
    private final DrinkRepository drinkRepository;

    public List<FeedPost> feed(int limit) {
        return feedPostRepository.findAllByOrderByCreatedAtDesc(PageRequest.of(0, limit));
    }

    @Transactional
    public void follow(User follower, UUID targetUserId) {
        User target = userRepository.findById(targetUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
        followRepository.findByFollowerAndFollowing(follower, target)
                .ifPresent(existing -> { throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Already following"); });
        followRepository.save(Follow.builder().follower(follower).following(target).build());
    }

    @Transactional
    public void unfollow(User follower, UUID targetUserId) {
        User target = userRepository.findById(targetUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
        followRepository.findByFollowerAndFollowing(follower, target)
                .ifPresentOrElse(followRepository::delete, () -> {
                    throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Not following");
                });
    }

    public List<Follow> followers(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
        return followRepository.findByFollowing(user);
    }

    public List<Follow> following(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
        return followRepository.findByFollower(user);
    }

    @Transactional
    public void like(User user, UUID drinkId) {
        Drink drink = drinkRepository.findById(drinkId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Drink not found"));
        likeRepository.findByUserAndDrink(user, drink)
                .ifPresent(existing -> { throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Already liked"); });
        likeRepository.save(Like.builder().user(user).drink(drink).build());
        drink.setLikesCount((drink.getLikesCount() == null ? 0 : drink.getLikesCount()) + 1);
        drinkRepository.save(drink);
    }

    @Transactional
    public void unlike(User user, UUID drinkId) {
        Drink drink = drinkRepository.findById(drinkId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Drink not found"));
        likeRepository.findByUserAndDrink(user, drink)
                .ifPresentOrElse(likeRepository::delete, () -> {
                    throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Not liked");
                });
        drink.setLikesCount(Math.max(0, (drink.getLikesCount() == null ? 0 : drink.getLikesCount()) - 1));
        drinkRepository.save(drink);
    }

    @Transactional
    public Comment addComment(User user, UUID drinkId, String content) {
        if (content == null || content.isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Content required");
        }
        Drink drink = drinkRepository.findById(drinkId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Drink not found"));
        Comment comment = Comment.builder()
                .user(user)
                .drink(drink)
                .content(content)
                .build();
        Comment saved = commentRepository.save(comment);
        drink.setCommentsCount((drink.getCommentsCount() == null ? 0 : drink.getCommentsCount()) + 1);
        drinkRepository.save(drink);
        return saved;
    }

    public List<Comment> comments(UUID drinkId) {
        Drink drink = drinkRepository.findById(drinkId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Drink not found"));
        return commentRepository.findByDrink(drink);
    }
}


