//
//  UserManager.swift
//  Siply
//
//  Created on October 4, 2025.
//

import Foundation
import Combine

class UserManager: ObservableObject {
    @Published var currentUser: User?
    
    private let userDefaults = UserDefaults.standard
    private let currentUserKey = "CurrentUser"
    
    init() {
        loadUser()
        
        // Create sample user if first launch
        if currentUser == nil {
            currentUser = User.sample
            saveUser()
        }
    }
    
    func updateUser(_ user: User) {
        currentUser = user
        saveUser()
    }
    
    func updateUserStats(totalDrinks: Int, totalLocations: Int, favoriteCategory: DrinkCategory?) {
        guard var user = currentUser else { return }
        user.totalDrinks = totalDrinks
        user.totalLocations = totalLocations
        user.favoriteCategory = favoriteCategory
        currentUser = user
        saveUser()
    }
    
    func setFavoriteDrink(_ drink: Drink) {
        guard var user = currentUser else { return }
        user.favoriteDrink = drink
        currentUser = user
        saveUser()
    }
    
    func incrementFollowers() {
        guard var user = currentUser else { return }
        user.followersCount += 1
        currentUser = user
        saveUser()
    }
    
    func incrementFollowing() {
        guard var user = currentUser else { return }
        user.followingCount += 1
        currentUser = user
        saveUser()
    }
    
    func updateDisplayName(_ name: String) {
        guard var user = currentUser else { return }
        user.displayName = name
        currentUser = user
        saveUser()
    }
    
    func updateBio(_ bio: String) {
        guard var user = currentUser else { return }
        user.bio = bio
        currentUser = user
        saveUser()
    }
    
    // MARK: - Persistence
    
    private func saveUser() {
        if let encoded = try? JSONEncoder().encode(currentUser) {
            userDefaults.set(encoded, forKey: currentUserKey)
        }
    }
    
    private func loadUser() {
        if let data = userDefaults.data(forKey: currentUserKey),
           let decoded = try? JSONDecoder().decode(User.self, from: data) {
            currentUser = decoded
        }
    }
    
    // MARK: - Data Management
    
    func resetUser() {
        currentUser = User.sample
        saveUser()
    }
    
    func exportUserData() -> Data? {
        return try? JSONEncoder().encode(currentUser)
    }
    
    func importUserData(_ data: Data) -> Bool {
        if let imported = try? JSONDecoder().decode(User.self, from: data) {
            currentUser = imported
            saveUser()
            return true
        }
        return false
    }
}

