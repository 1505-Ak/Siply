package com.siply.backend.social;

import com.siply.backend.users.User;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/social")
@RequiredArgsConstructor
public class SocialController {

    private final SocialService socialService;

    @GetMapping("/feed")
    public ResponseEntity<List<FeedPost>> feed(@RequestParam(defaultValue = "20") int limit) {
        return ResponseEntity.ok(socialService.feed(limit));
    }

    @PostMapping("/follow/{userId}")
    public ResponseEntity<Void> follow(@AuthenticationPrincipal User me, @PathVariable UUID userId) {
        if (me == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        socialService.follow(me, userId);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/follow/{userId}")
    public ResponseEntity<Void> unfollow(@AuthenticationPrincipal User me, @PathVariable UUID userId) {
        if (me == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        socialService.unfollow(me, userId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/followers/{userId}")
    public ResponseEntity<List<Follow>> followers(@PathVariable UUID userId) {
        return ResponseEntity.ok(socialService.followers(userId));
    }

    @GetMapping("/following/{userId}")
    public ResponseEntity<List<Follow>> following(@PathVariable UUID userId) {
        return ResponseEntity.ok(socialService.following(userId));
    }

    @PostMapping("/likes/{drinkId}")
    public ResponseEntity<Void> like(@AuthenticationPrincipal User me, @PathVariable UUID drinkId) {
        if (me == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        socialService.like(me, drinkId);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/likes/{drinkId}")
    public ResponseEntity<Void> unlike(@AuthenticationPrincipal User me, @PathVariable UUID drinkId) {
        if (me == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        socialService.unlike(me, drinkId);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/comments/{drinkId}")
    public ResponseEntity<Comment> comment(
            @AuthenticationPrincipal User me,
            @PathVariable UUID drinkId,
            @RequestBody Map<String, String> payload
    ) {
        if (me == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        String content = payload.getOrDefault("content", "");
        return ResponseEntity.status(HttpStatus.CREATED).body(socialService.addComment(me, drinkId, content));
    }

    @GetMapping("/comments/{drinkId}")
    public ResponseEntity<List<Comment>> comments(@PathVariable UUID drinkId) {
        return ResponseEntity.ok(socialService.comments(drinkId));
    }
}


