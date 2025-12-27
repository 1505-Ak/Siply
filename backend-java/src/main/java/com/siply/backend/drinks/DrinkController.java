package com.siply.backend.drinks;

import com.siply.backend.drinks.dto.DrinkRequest;
import com.siply.backend.drinks.dto.DrinkResponse;
import com.siply.backend.users.User;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/drinks")
@RequiredArgsConstructor
public class DrinkController {

    private final DrinkService drinkService;

    @GetMapping
    public ResponseEntity<List<DrinkResponse>> list() {
        return ResponseEntity.ok(drinkService.listAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<DrinkResponse> get(@PathVariable UUID id) {
        return ResponseEntity.ok(drinkService.get(id));
    }

    @GetMapping("/trending/all")
    public ResponseEntity<List<DrinkResponse>> trending() {
        return ResponseEntity.ok(drinkService.trendingAll());
    }

    @PostMapping
    public ResponseEntity<DrinkResponse> create(
            @AuthenticationPrincipal User user,
            @Validated @RequestBody DrinkRequest request
    ) {
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        return ResponseEntity.status(HttpStatus.CREATED).body(drinkService.create(user, request));
    }

    @PutMapping("/{id}")
    public ResponseEntity<DrinkResponse> update(
            @PathVariable UUID id,
            @AuthenticationPrincipal User user,
            @Validated @RequestBody DrinkRequest request
    ) {
        if (user == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        return ResponseEntity.ok(drinkService.update(id, user, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(
            @PathVariable UUID id,
            @AuthenticationPrincipal User user
    ) {
        if (user == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        drinkService.delete(id, user);
        return ResponseEntity.noContent().build();
    }
}


