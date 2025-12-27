//
//  AchievementManager.swift
//  Siply
//
//  Created on October 4, 2025.
//

import Foundation
import SwiftUI
import Combine

class AchievementManager: ObservableObject {
    @Published var unlockedAchievements: Set<Achievement> = []
    @Published var showingAchievement: Achievement?
    
    private let userDefaults = UserDefaults.standard
    private let achievementsKey = "UnlockedAchievements"
    
    init() {
        loadAchievements()
    }
    
    func checkAchievements(drinkCount: Int, locationCount: Int, hasAllCategories: Bool, hasFiveStarRating: Bool) {
        var newAchievements: [Achievement] = []
        
        // Drink count achievements
        if drinkCount >= 1 && !unlockedAchievements.contains(.firstDrink) {
            newAchievements.append(.firstDrink)
        }
        if drinkCount >= 5 && !unlockedAchievements.contains(.fiveDrinks) {
            newAchievements.append(.fiveDrinks)
        }
        if drinkCount >= 10 && !unlockedAchievements.contains(.tenDrinks) {
            newAchievements.append(.tenDrinks)
        }
        if drinkCount >= 25 && !unlockedAchievements.contains(.twentyFiveDrinks) {
            newAchievements.append(.twentyFiveDrinks)
        }
        if drinkCount >= 50 && !unlockedAchievements.contains(.fiftyDrinks) {
            newAchievements.append(.fiftyDrinks)
        }
        if drinkCount >= 100 && !unlockedAchievements.contains(.hundredDrinks) {
            newAchievements.append(.hundredDrinks)
        }
        
        // Location achievement
        if locationCount >= 10 && !unlockedAchievements.contains(.tenLocations) {
            newAchievements.append(.tenLocations)
        }
        
        // Category achievement
        if hasAllCategories && !unlockedAchievements.contains(.allCategories) {
            newAchievements.append(.allCategories)
        }
        
        // Rating achievement
        if hasFiveStarRating && !unlockedAchievements.contains(.fiveStarRating) {
            newAchievements.append(.fiveStarRating)
        }
        
        // Unlock new achievements
        for achievement in newAchievements {
            unlockAchievement(achievement)
        }
    }
    
    private func unlockAchievement(_ achievement: Achievement) {
        unlockedAchievements.insert(achievement)
        showingAchievement = achievement
        HapticManager.shared.notification(type: .success)
        saveAchievements()
    }
    
    private func saveAchievements() {
        let achievementStrings = unlockedAchievements.map { $0.rawValue }
        userDefaults.set(achievementStrings, forKey: achievementsKey)
    }
    
    private func loadAchievements() {
        if let achievementStrings = userDefaults.stringArray(forKey: achievementsKey) {
            unlockedAchievements = Set(achievementStrings.compactMap { Achievement(rawValue: $0) })
        }
    }
}
