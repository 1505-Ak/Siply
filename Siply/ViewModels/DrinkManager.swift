//
//  DrinkManager.swift
//  Siply
//
//  Created on October 4, 2025.
//

import Foundation
import Combine

class DrinkManager: ObservableObject {
    @Published var drinks: [Drink] = []
    @Published var filteredDrinks: [Drink] = []
    @Published var selectedCategory: DrinkCategory?
    @Published var searchText: String = ""
    @Published var drinkOfTheDay: Drink?
    
    private let userDefaults = UserDefaults.standard
    private let drinksKey = "SavedDrinks"
    private let drinkOfDayKey = "DrinkOfTheDay"
    private let lastUpdateKey = "LastDrinkOfDayUpdate"
    private let lastBackupKey = "LastBackupDate"
    
    init() {
        loadDrinks()
        
        // Load sample data if first launch
        if drinks.isEmpty {
            drinks = Drink.sampleDrinks
            saveDrinks()
        }
        
        filteredDrinks = drinks
        updateDrinkOfTheDay()
        performAutoBackup()
    }
    
    func addDrink(_ drink: Drink) {
        drinks.insert(drink, at: 0)
        saveDrinks()
        filterDrinks()
    }
    
    func updateDrink(_ drink: Drink) {
        if let index = drinks.firstIndex(where: { $0.id == drink.id }) {
            drinks[index] = drink
            saveDrinks()
            filterDrinks()
        }
    }
    
    func deleteDrink(_ drink: Drink) {
        drinks.removeAll { $0.id == drink.id }
        saveDrinks()
        filterDrinks()
    }
    
    func toggleFavorite(_ drink: Drink) {
        if let index = drinks.firstIndex(where: { $0.id == drink.id }) {
            drinks[index].isFavorite.toggle()
            saveDrinks()
            filterDrinks()
        }
    }
    
    func filterDrinks() {
        var result = drinks
        
        // Filter by category
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.locationName.localizedCaseInsensitiveContains(searchText) ||
                $0.notes.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        filteredDrinks = result
    }
    
    func getRecommendations(limit: Int = 10) -> [Drink] {
        // Simple recommendation algorithm: highest rated drinks
        // Can be enhanced with ML later
        return drinks.sorted { $0.rating > $1.rating }.prefix(limit).map { $0 }
    }
    
    func getTrendingDrinks(limit: Int = 10) -> [Drink] {
        // Sort by likes (social engagement)
        return drinks.sorted { $0.likes > $1.likes }.prefix(limit).map { $0 }
    }
    
    func getFavoriteDrinks() -> [Drink] {
        return drinks.filter { $0.isFavorite }
    }
    
    func getDrinksByCategory(_ category: DrinkCategory) -> [Drink] {
        return drinks.filter { $0.category == category }
    }
    
    // MARK: - Persistence
    
    private func saveDrinks() {
        if let encoded = try? JSONEncoder().encode(drinks) {
            userDefaults.set(encoded, forKey: drinksKey)
        }
    }
    
    private func loadDrinks() {
        if let data = userDefaults.data(forKey: drinksKey),
           let decoded = try? JSONDecoder().decode([Drink].self, from: data) {
            drinks = decoded
        }
    }
    
    // MARK: - Analytics
    
    func getTotalDrinks() -> Int {
        return drinks.count
    }
    
    func getTotalLocations() -> Int {
        let uniqueLocations = Set(drinks.map { $0.locationName })
        return uniqueLocations.count
    }
    
    func getAverageRating() -> Double {
        guard !drinks.isEmpty else { return 0 }
        let sum = drinks.reduce(0) { $0 + $1.rating }
        return sum / Double(drinks.count)
    }
    
    func getMostLoggedCategory() -> DrinkCategory? {
        let categories = drinks.map { $0.category }
        let counted = categories.reduce(into: [:]) { counts, category in
            counts[category, default: 0] += 1
        }
        return counted.max(by: { $0.value < $1.value })?.key
    }
    
    // MARK: - Drink of the Day
    
    func updateDrinkOfTheDay() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastUpdate = userDefaults.object(forKey: lastUpdateKey) as? Date,
           calendar.isDate(lastUpdate, inSameDayAs: today),
           let savedDrinkId = userDefaults.string(forKey: drinkOfDayKey),
           let savedDrink = drinks.first(where: { $0.id.uuidString == savedDrinkId }) {
            drinkOfTheDay = savedDrink
        } else {
            // Select a new drink of the day
            if let randomDrink = drinks.randomElement() {
                drinkOfTheDay = randomDrink
                userDefaults.set(randomDrink.id.uuidString, forKey: drinkOfDayKey)
                userDefaults.set(Date(), forKey: lastUpdateKey)
            }
        }
    }
    
    func hasAllCategories() -> Bool {
        let loggedCategories = Set(drinks.map { $0.category })
        return loggedCategories.count == DrinkCategory.allCases.count
    }
    
    func hasFiveStarRating() -> Bool {
        return drinks.contains { $0.rating == 5.0 }
    }
    
    // MARK: - Data Management
    
    func clearAllData() {
        drinks = []
        saveDrinks()
        filterDrinks()
    }
    
    func exportData() -> Data? {
        return try? JSONEncoder().encode(drinks)
    }
    
    func importData(_ data: Data) -> Bool {
        if let imported = try? JSONDecoder().decode([Drink].self, from: data) {
            drinks = imported
            saveDrinks()
            filterDrinks()
            return true
        }
        return false
    }
    
    private func performAutoBackup() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastBackup = userDefaults.object(forKey: lastBackupKey) as? Date {
            let daysSinceBackup = calendar.dateComponents([.day], from: lastBackup, to: today).day ?? 0
            if daysSinceBackup < 7 {
                return // Backup is recent
            }
        }
        
        // Perform backup
        if let backupData = exportData() {
            userDefaults.set(backupData, forKey: "BackupData")
            userDefaults.set(Date(), forKey: lastBackupKey)
        }
    }
    
    func restoreFromBackup() -> Bool {
        if let backupData = userDefaults.data(forKey: "BackupData") {
            return importData(backupData)
        }
        return false
    }
    
    // MARK: - Advanced Filtering
    
    func getDrinksByRating(minRating: Double) -> [Drink] {
        return drinks.filter { $0.rating >= minRating }
    }
    
    func getDrinksByDateRange(start: Date, end: Date) -> [Drink] {
        return drinks.filter { $0.date >= start && $0.date <= end }
    }
    
    func getDrinksByPriceRange(min: Double, max: Double) -> [Drink] {
        return drinks.filter {
            guard let price = $0.price else { return false }
            return price >= min && price <= max
        }
    }
    
    // MARK: - Statistics
    
    func getTotalSpent() -> Double {
        return drinks.compactMap { $0.price }.reduce(0, +)
    }
    
    func getAveragePricePerCategory() -> [DrinkCategory: Double] {
        var result: [DrinkCategory: Double] = [:]
        for category in DrinkCategory.allCases {
            let categoryDrinks = drinks.filter { $0.category == category }
            let prices = categoryDrinks.compactMap { $0.price }
            if !prices.isEmpty {
                result[category] = prices.reduce(0, +) / Double(prices.count)
            }
        }
        return result
    }
    
    func getMostVisitedLocation() -> String? {
        let locations = drinks.map { $0.locationName }
        let counted = locations.reduce(into: [:]) { counts, location in
            counts[location, default: 0] += 1
        }
        return counted.max(by: { $0.value < $1.value })?.key
    }
}
