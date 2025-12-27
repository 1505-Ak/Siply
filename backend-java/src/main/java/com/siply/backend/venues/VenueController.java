package com.siply.backend.venues;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/venues")
@RequiredArgsConstructor
public class VenueController {

    private final VenueService venueService;

    @GetMapping
    public ResponseEntity<List<Venue>> list() {
        return ResponseEntity.ok(venueService.listAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Venue> get(@PathVariable UUID id) {
        return ResponseEntity.ok(venueService.get(id));
    }

    @GetMapping("/nearby/search")
    public ResponseEntity<List<Venue>> nearby(@RequestParam(required = false) String city) {
        return ResponseEntity.ok(venueService.nearby(city));
    }

    @GetMapping("/discounts/student")
    public ResponseEntity<List<Discount>> student() {
        return ResponseEntity.ok(venueService.studentDiscounts());
    }

    @GetMapping("/discounts/happy-hour")
    public ResponseEntity<List<Discount>> happyHour() {
        return ResponseEntity.ok(venueService.happyHour());
    }

    @GetMapping("/{id}/discounts")
    public ResponseEntity<List<Discount>> discountsForVenue(@PathVariable UUID id) {
        return ResponseEntity.ok(venueService.discountsForVenue(id));
    }

    @GetMapping("/{id}/loyalty")
    public ResponseEntity<List<LoyaltyProgram>> loyalty(@PathVariable UUID id) {
        return ResponseEntity.ok(venueService.loyaltyForVenue(id));
    }
}


