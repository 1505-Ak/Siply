package com.siply.backend.venues;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface VenueRepository extends JpaRepository<Venue, UUID> {
    List<Venue> findByCityIgnoreCase(String city);
    List<Venue> findByCategoryIgnoreCase(String category);
    List<Venue> findByIsPartnerTrue();
}


