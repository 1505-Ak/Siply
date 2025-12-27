package com.siply.backend.auth;

import com.siply.backend.users.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.Instant;
import java.util.Optional;
import java.util.UUID;

public interface RefreshTokenRepository extends JpaRepository<RefreshToken, UUID> {
    Optional<RefreshToken> findByTokenHash(String tokenHash);
    void deleteByUser(User user);
    void deleteByExpiresAtBefore(Instant timestamp);
}


