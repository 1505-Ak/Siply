//
//  Drink.swift
//  Siply
//
//  Created on October 4, 2025.
//

import Foundation
import CoreLocation

enum DrinkCategory: String, CaseIterable, Codable {
    case cocktail = "Cocktail"
    case mocktail = "Mocktail"
    case coffee = "Coffee"
    case bubbleTea = "Bubble Tea"
    case craftBeer = "Craft Beer"
    case wine = "Wine"
    case smoothie = "Smoothie"
    case juice = "Juice"
    case tea = "Tea"
    case soda = "Soda"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .cocktail: return "🍸"
        case .mocktail: return "🍹"
        case .coffee: return "☕️"
        case .bubbleTea: return "🧋"
        case .craftBeer: return "🍺"
        case .wine: return "🍷"
        case .smoothie: return "🥤"
        case .juice: return "🧃"
        case .tea: return "🍵"
        case .soda: return "🥤"
        case .other: return "🥛"
        }
    }
}

struct Drink: Identifiable, Codable {
    var id = UUID()
    var name: String
    var category: DrinkCategory
    var rating: Double // 0-5
    var notes: String
    var imageName: String?
    var imageData: Data? // Store actual photo data
    var locationName: String
    var latitude: Double?
    var longitude: Double?
    var date: Date
    var tags: [String]
    var price: Double?
    var isFavorite: Bool
    
    // Social features
    var isPublic: Bool
    var likes: Int
    var shares: Int
    
    var coordinate: CLLocationCoordinate2D? {
        guard let lat = latitude, let lon = longitude else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    init(
        name: String,
        category: DrinkCategory,
        rating: Double,
        notes: String = "",
        imageName: String? = nil,
        imageData: Data? = nil,
        locationName: String,
        latitude: Double? = nil,
        longitude: Double? = nil,
        date: Date = Date(),
        tags: [String] = [],
        price: Double? = nil,
        isFavorite: Bool = false,
        isPublic: Bool = true,
        likes: Int = 0,
        shares: Int = 0
    ) {
        self.name = name
        self.category = category
        self.rating = rating
        self.notes = notes
        self.imageName = imageName
        self.imageData = imageData
        self.locationName = locationName
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.tags = tags
        self.price = price
        self.isFavorite = isFavorite
        self.isPublic = isPublic
        self.likes = likes
        self.shares = shares
    }
}

// Sample data for preview/testing
extension Drink {
    static let sampleDrinks: [Drink] = [
        Drink(
            name: "Espresso Martini",
            category: .cocktail,
            rating: 4.5,
            notes: "Perfectly balanced, not too sweet. Great coffee flavor!",
            locationName: "The Cocktail Bar, London",
            latitude: 51.5074,
            longitude: -0.1278,
            tags: ["espresso", "vodka", "coffee"],
            price: 12.50,
            likes: 24
        ),
        Drink(
            name: "Matcha Latte",
            category: .coffee,
            rating: 5.0,
            notes: "Best matcha I've ever had. Creamy and smooth.",
            locationName: "Zen Coffee House, Tokyo",
            latitude: 35.6762,
            longitude: 139.6503,
            tags: ["matcha", "green tea", "latte"],
            price: 6.00,
            isFavorite: true,
            likes: 156
        ),
        Drink(
            name: "Classic Brown Sugar Milk Tea",
            category: .bubbleTea,
            rating: 4.0,
            notes: "Tapioca pearls were perfect. A bit too sweet for my taste.",
            locationName: "Boba Paradise, San Francisco",
            latitude: 37.7749,
            longitude: -122.4194,
            tags: ["boba", "milk tea", "tapioca"],
            price: 5.50,
            likes: 89
        ),
        Drink(
            name: "Hazy IPA",
            category: .craftBeer,
            rating: 4.8,
            notes: "Tropical notes, super smooth. Low bitterness.",
            locationName: "Craft Brew Co, Portland",
            latitude: 45.5152,
            longitude: -122.6784,
            tags: ["IPA", "hoppy", "citrus"],
            price: 8.00,
            likes: 67
        )
    ]
    
    static var sample: Drink {
        sampleDrinks[0]
    }
}
