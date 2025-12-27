package com.siply.backend.drinks;

import com.siply.backend.users.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface DrinkRepository extends JpaRepository<Drink, UUID> {
    List<Drink> findByUser(User user);
    List<Drink> findAllByOrderByLikesCountDesc();
    long countByUser(User user);
}


