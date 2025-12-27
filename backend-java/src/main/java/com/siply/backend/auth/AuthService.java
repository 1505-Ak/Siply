package com.siply.backend.auth;

import com.siply.backend.auth.dto.AuthResponse;
import com.siply.backend.auth.dto.LoginRequest;
import com.siply.backend.auth.dto.RegisterRequest;
import com.siply.backend.auth.dto.UserResponse;
import com.siply.backend.config.JwtService;
import com.siply.backend.users.User;
import com.siply.backend.users.UserRepository;
import org.springframework.beans.factory.annotation.Value;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;
    private final RefreshTokenRepository refreshTokenRepository;

    @Value("${app.jwt.refresh-ttl-ms:2592000000}")
    private long refreshTtlMs;

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByUsername(request.username())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Username already taken");
        }
        if (userRepository.existsByEmail(request.email())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Email already registered");
        }

        User user = User.builder()
                .username(request.username())
                .email(request.email())
                .displayName(request.displayName())
                .passwordHash(passwordEncoder.encode(request.password()))
                .isActive(true)
                .isVerified(false)
                .followersCount(0)
                .followingCount(0)
                .totalCities(0)
                .totalCountries(0)
                .totalDrinks(0)
                .build();

        User saved = userRepository.save(user);
        return buildAuthResponse(saved, true);
    }

    public AuthResponse login(LoginRequest request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.username(),
                        request.password()
                )
        );

        User user = userRepository.findByUsername(request.username())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid credentials"));

        return buildAuthResponse(user, true);
    }

    public User findUser(String username) {
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
    }

    public AuthResponse refresh(String refreshToken) {
        String hash = hash(refreshToken);
        RefreshToken stored = refreshTokenRepository.findByTokenHash(hash)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid refresh token"));
        if (stored.getExpiresAt().isBefore(java.time.Instant.now())) {
            refreshTokenRepository.delete(stored);
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Refresh token expired");
        }
        return buildAuthResponse(stored.getUser(), false);
    }

    private AuthResponse buildAuthResponse(User user, boolean issueRefresh) {
        String accessToken = jwtService.generateAccessToken(user);
        String refreshToken = null;
        if (issueRefresh) {
            refreshTokenRepository.deleteByUser(user);
            String plainRefresh = java.util.UUID.randomUUID().toString();
            RefreshToken token = RefreshToken.builder()
                    .user(user)
                    .tokenHash(hash(plainRefresh))
                    .expiresAt(java.time.Instant.now().plusMillis(refreshTtlMs))
                    .build();
            refreshTokenRepository.save(token);
            refreshToken = plainRefresh;
        }
        return new AuthResponse(accessToken, refreshToken, toResponse(user));
    }

    public UserResponse toResponse(User user) {
        return UserResponse.builder()
                .id(user.getId())
                .username(user.getUsername())
                .email(user.getEmail())
                .displayName(user.getDisplayName())
                .bio(user.getBio())
                .avatarUrl(user.getAvatarUrl())
                .favoriteDrink(user.getFavoriteDrink())
                .followersCount(user.getFollowersCount())
                .followingCount(user.getFollowingCount())
                .totalDrinks(user.getTotalDrinks())
                .totalCities(user.getTotalCities())
                .totalCountries(user.getTotalCountries())
                .build();
    }

    private String hash(String token) {
        try {
            java.security.MessageDigest digest = java.security.MessageDigest.getInstance("SHA-256");
            byte[] encodedHash = digest.digest(token.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder(2 * encodedHash.length);
            for (byte b : encodedHash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            throw new RuntimeException("Failed to hash token", e);
        }
    }
}


