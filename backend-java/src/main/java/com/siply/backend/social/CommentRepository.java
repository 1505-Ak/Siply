package com.siply.backend.social;

import com.siply.backend.drinks.Drink;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface CommentRepository extends JpaRepository<Comment, UUID> {
    List<Comment> findByDrink(Drink drink);
}


