package com.siply.backend.users;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.time.Instant;
import java.util.Collection;
import java.util.Collections;
import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "users")
public class User implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @Column(nullable = false, unique = true, length = 50)
    private String username;

    @Column(nullable = false, unique = true, length = 255)
    private String email;

    @JsonIgnore
    @Column(name = "password_hash", nullable = false, length = 255)
    private String passwordHash;

    @Column(name = "display_name", nullable = false, length = 100)
    private String displayName;

    private String bio;
    @Column(name = "avatar_url")
    private String avatarUrl;
    @Column(name = "favorite_drink")
    private String favoriteDrink;

    @Column(name = "followers_count")
    private Integer followersCount;
    @Column(name = "following_count")
    private Integer followingCount;
    @Column(name = "total_drinks")
    private Integer totalDrinks;
    @Column(name = "total_cities")
    private Integer totalCities;
    @Column(name = "total_countries")
    private Integer totalCountries;

    @Column(name = "created_at", updatable = false, insertable = false)
    private Instant createdAt;
    @Column(name = "updated_at", insertable = false)
    private Instant updatedAt;
    @Column(name = "last_login")
    private Instant lastLogin;

    @Column(name = "is_verified")
    private Boolean isVerified;
    @Column(name = "is_active")
    private Boolean isActive;

    @Override
    @JsonIgnore
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return Collections.emptyList();
    }

    @Override
    @JsonIgnore
    public String getPassword() {
        return passwordHash;
    }

    @Override
    public String getUsername() {
        return username;
    }

    @Override
    @JsonIgnore
    public boolean isAccountNonExpired() {
        return Boolean.TRUE.equals(isActive);
    }

    @Override
    @JsonIgnore
    public boolean isAccountNonLocked() {
        return Boolean.TRUE.equals(isActive);
    }

    @Override
    @JsonIgnore
    public boolean isCredentialsNonExpired() {
        return Boolean.TRUE.equals(isActive);
    }

    @Override
    @JsonIgnore
    public boolean isEnabled() {
        return Boolean.TRUE.equals(isActive);
    }
}


