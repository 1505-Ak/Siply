package com.siply.backend.social;

import com.siply.backend.drinks.Drink;
import com.siply.backend.users.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface LikeRepository extends JpaRepository<Like, UUID> {
    Optional<Like> findByUserAndDrink(User user, Drink drink);
    long countByDrink(Drink drink);
}


