package com.siply.backend.social;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.UUID;

public interface FeedPostRepository extends JpaRepository<FeedPost, UUID> {
    List<FeedPost> findAllByOrderByCreatedAtDesc(Pageable pageable);
}


