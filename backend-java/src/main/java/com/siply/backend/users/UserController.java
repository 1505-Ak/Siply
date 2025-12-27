package com.siply.backend.users;

import com.siply.backend.drinks.DrinkService;
import com.siply.backend.drinks.dto.DrinkResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final DrinkService drinkService;

    @GetMapping("/{username}")
    public ResponseEntity<User> profile(@PathVariable String username) {
        return ResponseEntity.ok(userService.getByUsername(username));
    }

    @PutMapping("/profile")
    public ResponseEntity<User> updateProfile(@AuthenticationPrincipal User me,
                                              @RequestBody UserUpdateRequest request) {
        if (me == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        return ResponseEntity.ok(userService.updateProfile(me, request));
    }

    @GetMapping("/{username}/drinks")
    public ResponseEntity<List<DrinkResponse>> userDrinks(@PathVariable String username) {
        User user = userService.getByUsername(username);
        return ResponseEntity.ok(drinkService.listForUser(user));
    }

    @GetMapping("/{username}/stats")
    public ResponseEntity<UserService.UserStats> stats(@PathVariable String username) {
        return ResponseEntity.ok(userService.stats(username));
    }

    @GetMapping("/search/query")
    public ResponseEntity<List<User>> search(@RequestParam String q) {
        return ResponseEntity.ok(userService.search(q));
    }
}


