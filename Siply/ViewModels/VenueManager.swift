//
//  VenueManager.swift
//  Siply
//
//  Manages all venues, discounts, and loyalty programs
//

import Foundation
import Combine

class VenueManager: ObservableObject {
    @Published var venues: [Venue] = []
    @Published var favoriteVenues: [Venue] = []
    
    private let venuesKey = "siply_venues"
    
    init() {
        loadVenues()
        if venues.isEmpty {
            loadSampleVenues()
        }
    }
    
    // MARK: - Data Persistence
    
    func saveVenues() {
        if let encoded = try? JSONEncoder().encode(venues) {
            UserDefaults.standard.set(encoded, forKey: venuesKey)
        }
    }
    
    func loadVenues() {
        if let data = UserDefaults.standard.data(forKey: venuesKey),
           let decoded = try? JSONDecoder().decode([Venue].self, from: data) {
            venues = decoded
            updateFavorites()
        }
    }
    
    // MARK: - Venue Management
    
    func toggleFavorite(venueId: UUID) {
        if let index = venues.firstIndex(where: { $0.id == venueId }) {
            venues[index].isFavorite.toggle()
            saveVenues()
            updateFavorites()
        }
    }
    
    func addVisit(to venueId: UUID, pointsEarned: Int = 10) {
        if let index = venues.firstIndex(where: { $0.id == venueId }) {
            venues[index].visitCount += 1
            venues[index].pointsEarned += pointsEarned
            saveVenues()
        }
    }
    
    func updateFavorites() {
        favoriteVenues = venues.filter { $0.isFavorite }
    }
    
    // MARK: - Filtering
    
    func getPartnerVenues() -> [Venue] {
        venues.filter { $0.isPartner }
    }
    
    func getNearbyVenues(userLocation: (lat: Double, lon: Double)? = nil) -> [Venue] {
        // For now, return all venues. In production, calculate distance
        return venues.prefix(10).map { $0 }
    }
    
    func getStudentDiscountVenues() -> [Venue] {
        venues.filter { $0.hasStudentDiscount }
    }
    
    func getHappyHourVenues() -> [Venue] {
        venues.filter { $0.hasHappyHour }
    }
    
    func getVenuesWithLoyaltyPrograms() -> [Venue] {
        venues.filter { $0.loyaltyProgram != nil }
    }
    
    func getVenuesWithMultiplier() -> [Venue] {
        venues.filter { $0.loyaltyProgram?.hasMultiplier == true }
    }
    
    func getVenuesWithSubscription() -> [Venue] {
        venues.filter { $0.loyaltyProgram?.hasSubscription == true }
    }
    
    func getVenuesWithVisitCard() -> [Venue] {
        venues.filter { $0.loyaltyProgram?.hasVisitCard == true }
    }
    
    func getVenuesWithExclusiveOffers() -> [Venue] {
        venues.filter { !($0.loyaltyProgram?.exclusiveOffers.isEmpty ?? true) }
    }
    
    func searchVenues(query: String) -> [Venue] {
        if query.isEmpty {
            return venues
        }
        return venues.filter {
            $0.name.localizedCaseInsensitiveContains(query) ||
            $0.category.rawValue.localizedCaseInsensitiveContains(query) ||
            $0.location.city.localizedCaseInsensitiveContains(query)
        }
    }
    
    // MARK: - Stats
    
    func getTotalPoints() -> Int {
        venues.reduce(0) { $0 + $1.pointsEarned }
    }
    
    func getTotalVisits() -> Int {
        venues.reduce(0) { $0 + $1.visitCount }
    }
    
    func getPointsForVenue(_ venueId: UUID) -> Int {
        venues.first(where: { $0.id == venueId })?.pointsEarned ?? 0
    }
    
    func getVisitsForVenue(_ venueId: UUID) -> Int {
        venues.first(where: { $0.id == venueId })?.visitCount ?? 0
    }
    
    func getAvailableOffersCount(for venueId: UUID) -> Int {
        guard let venue = venues.first(where: { $0.id == venueId }) else { return 0 }
        return venue.discounts.count + (venue.loyaltyProgram?.exclusiveOffers.count ?? 0)
    }
    
    // MARK: - Sample Data
    
    private func loadSampleVenues() {
        venues = [
            // Starbucks
            Venue(
                name: "Starbucks",
                category: .coffeehouse,
                location: VenueLocation(
                    address: "123 Main St",
                    city: "New York",
                    country: "USA",
                    latitude: 40.7128,
                    longitude: -74.0060
                ),
                hasStudentDiscount: true,
                hasHappyHour: false,
                discounts: [
                    Discount(
                        title: "Student Discount",
                        description: "10% off all drinks with valid student ID",
                        discountPercentage: 10,
                        requiresStudentID: true
                    ),
                    Discount(
                        title: "Free Birthday Drink",
                        description: "Get a free drink of your choice on your birthday",
                        discountAmount: "1 Free Drink"
                    )
                ],
                loyaltyProgram: LoyaltyProgram(
                    programType: .points,
                    pointsPerVisit: 10,
                    pointsPerDollar: 2,
                    hasMultiplier: true,
                    multiplierRate: 2.0,
                    hasVisitCard: true,
                    visitCardGoal: 10,
                    exclusiveOffers: [
                        Discount(
                            title: "Gold Member Offer",
                            description: "Double stars every Tuesday",
                            discountPercentage: 100
                        )
                    ]
                ),
                isPartner: true,
                pointsEarned: 200,
                imageIcon: "☕️"
            ),
            
            // Costa Coffee
            Venue(
                name: "Costa Coffee",
                category: .coffeehouse,
                location: VenueLocation(
                    address: "456 High St",
                    city: "London",
                    country: "UK",
                    latitude: 51.5074,
                    longitude: -0.1278
                ),
                hasStudentDiscount: true,
                hasHappyHour: true,
                happyHourDetails: HappyHourDetails(
                    days: ["Monday", "Tuesday", "Wednesday"],
                    startTime: "15:00",
                    endTime: "17:00",
                    discount: "30% off all iced drinks"
                ),
                discounts: [
                    Discount(
                        title: "Happy Hour Special",
                        description: "30% off iced drinks 3-5pm weekdays",
                        discountPercentage: 30
                    )
                ],
                loyaltyProgram: LoyaltyProgram(
                    programType: .visitCard,
                    pointsPerVisit: 15,
                    hasVisitCard: true,
                    visitCardGoal: 8
                ),
                isPartner: true,
                pointsEarned: 120,
                imageIcon: "☕️"
            ),
            
            // Local Brew
            Venue(
                name: "Local Brew",
                category: .cafe,
                location: VenueLocation(
                    address: "789 Oak Ave",
                    city: "San Francisco",
                    country: "USA",
                    latitude: 37.7749,
                    longitude: -122.4194
                ),
                hasStudentDiscount: true,
                hasHappyHour: true,
                happyHourDetails: HappyHourDetails(
                    days: ["Thursday", "Friday"],
                    startTime: "17:00",
                    endTime: "19:00",
                    discount: "50% off all drinks"
                ),
                discounts: [
                    Discount(
                        title: "Student Special",
                        description: "15% off with student ID",
                        discountPercentage: 15,
                        requiresStudentID: true
                    )
                ],
                loyaltyProgram: LoyaltyProgram(
                    hasVisitCard: true,
                    visitCardGoal: 5
                ),
                isPartner: false,
                imageIcon: "☕️"
            ),
            
            // Blue Bottle Coffee
            Venue(
                name: "Blue Bottle Coffee",
                category: .coffeehouse,
                location: VenueLocation(
                    address: "321 Market St",
                    city: "San Francisco",
                    country: "USA",
                    latitude: 37.7849,
                    longitude: -122.4094
                ),
                hasStudentDiscount: false,
                hasHappyHour: false,
                loyaltyProgram: LoyaltyProgram(
                    programType: .subscription,
                    hasSubscription: true,
                    subscriptionDetails: "$20/month for 20% off all drinks"
                ),
                isPartner: true,
                imageIcon: "☕️"
            ),
            
            // Pret A Manger
            Venue(
                name: "Pret A Manger",
                category: .cafe,
                location: VenueLocation(
                    address: "555 Broadway",
                    city: "New York",
                    country: "USA",
                    latitude: 40.7589,
                    longitude: -73.9851
                ),
                hasStudentDiscount: false,
                hasHappyHour: false,
                loyaltyProgram: LoyaltyProgram(
                    programType: .subscription,
                    hasSubscription: true,
                    subscriptionDetails: "$30/month for unlimited coffee"
                ),
                isPartner: true,
                imageIcon: "☕️"
            ),
            
            // Dunkin'
            Venue(
                name: "Dunkin'",
                category: .coffeehouse,
                location: VenueLocation(
                    address: "777 Washington St",
                    city: "Boston",
                    country: "USA",
                    latitude: 42.3601,
                    longitude: -71.0589
                ),
                hasStudentDiscount: true,
                hasHappyHour: true,
                happyHourDetails: HappyHourDetails(
                    days: ["Monday", "Wednesday", "Friday"],
                    startTime: "14:00",
                    endTime: "16:00",
                    discount: "Any size iced coffee for $2"
                ),
                discounts: [
                    Discount(
                        title: "Student Saver",
                        description: "10% off all purchases",
                        discountPercentage: 10,
                        requiresStudentID: true
                    )
                ],
                loyaltyProgram: LoyaltyProgram(
                    pointsPerDollar: 5,
                    hasMultiplier: true,
                    multiplierRate: 1.5
                ),
                isPartner: true,
                pointsEarned: 85,
                imageIcon: "🍩"
            )
        ]
        
        saveVenues()
    }
}


