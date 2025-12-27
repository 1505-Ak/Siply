//
//  Venue.swift
//  Siply
//
//  Created for Discounts & Loyalty System
//

import Foundation
import CoreLocation

struct Venue: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: VenueCategory
    var location: VenueLocation
    var hasStudentDiscount: Bool
    var hasHappyHour: Bool
    var happyHourDetails: HappyHourDetails?
    var discounts: [Discount]
    var loyaltyProgram: LoyaltyProgram?
    var isPartner: Bool // Featured partner
    var isFavorite: Bool
    var visitCount: Int
    var pointsEarned: Int
    var imageIcon: String // System icon or emoji
    
    init(
        id: UUID = UUID(),
        name: String,
        category: VenueCategory,
        location: VenueLocation,
        hasStudentDiscount: Bool = false,
        hasHappyHour: Bool = false,
        happyHourDetails: HappyHourDetails? = nil,
        discounts: [Discount] = [],
        loyaltyProgram: LoyaltyProgram? = nil,
        isPartner: Bool = false,
        isFavorite: Bool = false,
        visitCount: Int = 0,
        pointsEarned: Int = 0,
        imageIcon: String = "cup.and.saucer.fill"
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.location = location
        self.hasStudentDiscount = hasStudentDiscount
        self.hasHappyHour = hasHappyHour
        self.happyHourDetails = happyHourDetails
        self.discounts = discounts
        self.loyaltyProgram = loyaltyProgram
        self.isPartner = isPartner
        self.isFavorite = isFavorite
        self.visitCount = visitCount
        self.pointsEarned = pointsEarned
        self.imageIcon = imageIcon
    }
}

struct VenueLocation: Codable {
    var address: String
    var city: String
    var country: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var distanceFromUser: Double? // in km, calculated dynamically
}

enum VenueCategory: String, Codable, CaseIterable {
    case cafe = "Café"
    case restaurant = "Restaurant"
    case bar = "Bar"
    case coffeehouse = "Coffee House"
    case teaHouse = "Tea House"
    case juice = "Juice Bar"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .cafe: return "☕️"
        case .restaurant: return "🍽️"
        case .bar: return "🍸"
        case .coffeehouse: return "☕️"
        case .teaHouse: return "🍵"
        case .juice: return "🥤"
        case .other: return "🥤"
        }
    }
}

struct HappyHourDetails: Codable {
    var days: [String] // ["Monday", "Tuesday", ...]
    var startTime: String // "17:00"
    var endTime: String // "19:00"
    var discount: String // "50% off all drinks"
    
    var isActiveNow: Bool {
        // TODO: Implement time checking
        return false
    }
}

struct Discount: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var discountPercentage: Int?
    var discountAmount: String?
    var requiresStudentID: Bool
    var validUntil: Date?
    var termsAndConditions: String
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        discountPercentage: Int? = nil,
        discountAmount: String? = nil,
        requiresStudentID: Bool = false,
        validUntil: Date? = nil,
        termsAndConditions: String = ""
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.discountPercentage = discountPercentage
        self.discountAmount = discountAmount
        self.requiresStudentID = requiresStudentID
        self.validUntil = validUntil
        self.termsAndConditions = termsAndConditions
    }
}

struct LoyaltyProgram: Codable {
    var programType: LoyaltyProgramType
    var pointsPerVisit: Int
    var pointsPerDollar: Int
    var hasMultiplier: Bool
    var multiplierRate: Double // 2x, 3x etc
    var hasSubscription: Bool
    var subscriptionDetails: String?
    var hasVisitCard: Bool
    var visitCardGoal: Int // Number of visits to get reward
    var exclusiveOffers: [Discount]
    
    init(
        programType: LoyaltyProgramType = .points,
        pointsPerVisit: Int = 10,
        pointsPerDollar: Int = 1,
        hasMultiplier: Bool = false,
        multiplierRate: Double = 1.0,
        hasSubscription: Bool = false,
        subscriptionDetails: String? = nil,
        hasVisitCard: Bool = false,
        visitCardGoal: Int = 10,
        exclusiveOffers: [Discount] = []
    ) {
        self.programType = programType
        self.pointsPerVisit = pointsPerVisit
        self.pointsPerDollar = pointsPerDollar
        self.hasMultiplier = hasMultiplier
        self.multiplierRate = multiplierRate
        self.hasSubscription = hasSubscription
        self.subscriptionDetails = subscriptionDetails
        self.hasVisitCard = hasVisitCard
        self.visitCardGoal = visitCardGoal
        self.exclusiveOffers = exclusiveOffers
    }
}

enum LoyaltyProgramType: String, Codable {
    case points = "Points"
    case visitCard = "Visit Card"
    case subscription = "Subscription"
    case tiered = "Tiered"
}


