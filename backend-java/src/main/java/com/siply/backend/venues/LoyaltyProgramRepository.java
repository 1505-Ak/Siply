package com.siply.backend.venues;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface LoyaltyProgramRepository extends JpaRepository<LoyaltyProgram, UUID> {
    List<LoyaltyProgram> findByVenueId(UUID venueId);
}


