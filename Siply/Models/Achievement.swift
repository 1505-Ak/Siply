//
//  Achievement.swift
//  Siply
//
//  Created on October 4, 2025.
//

import Foundation

enum Achievement: String, CaseIterable, Codable {
    case firstDrink = "First Sip"
    case fiveDrinks = "Getting Started"
    case tenDrinks = "Regular"
    case twentyFiveDrinks = "Enthusiast"
    case fiftyDrinks = "Connoisseur"
    case hundredDrinks = "Legend"
    case fiveStarRating = "Perfectionist"
    case tenLocations = "Explorer"
    case allCategories = "Versatile"
    case threeDaysStreak = "Consistent"
    case weekStreak = "Dedicated"
    
    var icon: String {
        switch self {
        case .firstDrink: return "🎉"
        case .fiveDrinks: return "⭐️"
        case .tenDrinks: return "🌟"
        case .twentyFiveDrinks: return "💫"
        case .fiftyDrinks: return "✨"
        case .hundredDrinks: return "👑"
        case .fiveStarRating: return "🏆"
        case .tenLocations: return "🗺️"
        case .allCategories: return "🎯"
        case .threeDaysStreak: return "🔥"
        case .weekStreak: return "💪"
        }
    }
    
    var description: String {
        switch self {
        case .firstDrink: return "Logged your first drink"
        case .fiveDrinks: return "Logged 5 drinks"
        case .tenDrinks: return "Logged 10 drinks"
        case .twentyFiveDrinks: return "Logged 25 drinks"
        case .fiftyDrinks: return "Logged 50 drinks"
        case .hundredDrinks: return "Logged 100 drinks!"
        case .fiveStarRating: return "Gave a 5-star rating"
        case .tenLocations: return "Visited 10 locations"
        case .allCategories: return "Tried all drink categories"
        case .threeDaysStreak: return "3-day logging streak"
        case .weekStreak: return "7-day logging streak"
        }
    }
    
    var color: String {
        switch self {
        case .firstDrink, .fiveDrinks: return "siplyJade"
        case .tenDrinks, .fiveStarRating: return "siplyLightBrown"
        case .twentyFiveDrinks, .tenLocations: return "siplyMagenta"
        case .fiftyDrinks, .allCategories: return "siplyJade"
        case .hundredDrinks, .threeDaysStreak, .weekStreak: return "siplyJade"
        }
    }
}


