package com.siply.backend.venues;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface DiscountRepository extends JpaRepository<Discount, UUID> {
    List<Discount> findByRequiresStudentIdTrue();
    List<Discount> findByVenue_HasHappyHourTrue();
}


