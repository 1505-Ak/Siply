package com.siply.backend.venues;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class VenueService {

    private final VenueRepository venueRepository;
    private final DiscountRepository discountRepository;
    private final LoyaltyProgramRepository loyaltyProgramRepository;

    public List<Venue> listAll() {
        return venueRepository.findAll();
    }

    public Venue get(UUID id) {
        return venueRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Venue not found"));
    }

    public List<Venue> nearby(String city) {
        if (city == null || city.isBlank()) {
            return listAll();
        }
        return venueRepository.findByCityIgnoreCase(city);
    }

    public List<Discount> studentDiscounts() {
        return discountRepository.findByRequiresStudentIdTrue();
    }

    public List<Discount> happyHour() {
        return discountRepository.findByVenue_HasHappyHourTrue();
    }

    public List<Discount> discountsForVenue(UUID venueId) {
        return discountRepository.findAll().stream()
                .filter(d -> d.getVenue() != null && venueId.equals(d.getVenue().getId()))
                .toList();
    }

    public List<LoyaltyProgram> loyaltyForVenue(UUID venueId) {
        return loyaltyProgramRepository.findByVenueId(venueId);
    }
}


