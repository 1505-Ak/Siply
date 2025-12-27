//
//  User.swift
//  Siply
//
//  Created on October 4, 2025.
//

import Foundation

struct User: Identifiable, Codable {
    var id = UUID()
    var username: String
    var displayName: String
    var email: String
    var bio: String
    var profileImageName: String?
    var favoriteDrink: Drink?
    var showFavoriteDrinkToFriendsOnly: Bool
    var joinDate: Date
    
    // Stats
    var totalDrinks: Int
    var totalLocations: Int
    var favoriteCategory: DrinkCategory?
    
    // Social
    var friendsCount: Int
    var followersCount: Int
    var followingCount: Int
    
    init(
        username: String,
        displayName: String,
        email: String,
        bio: String = "",
        profileImageName: String? = nil,
        favoriteDrink: Drink? = nil,
        showFavoriteDrinkToFriendsOnly: Bool = false,
        joinDate: Date = Date(),
        totalDrinks: Int = 0,
        totalLocations: Int = 0,
        favoriteCategory: DrinkCategory? = nil,
        friendsCount: Int = 0,
        followersCount: Int = 0,
        followingCount: Int = 0
    ) {
        self.username = username
        self.displayName = displayName
        self.email = email
        self.bio = bio
        self.profileImageName = profileImageName
        self.favoriteDrink = favoriteDrink
        self.showFavoriteDrinkToFriendsOnly = showFavoriteDrinkToFriendsOnly
        self.joinDate = joinDate
        self.totalDrinks = totalDrinks
        self.totalLocations = totalLocations
        self.favoriteCategory = favoriteCategory
        self.friendsCount = friendsCount
        self.followersCount = followersCount
        self.followingCount = followingCount
    }
}

extension User {
    static var sample: User {
        User(
            username: "drinkexplorer",
            displayName: "Alex Johnson",
            email: "alex@example.com",
            bio: "Coffee addict ☕️ | Cocktail enthusiast 🍸 | Exploring the world one sip at a time",
            totalDrinks: 127,
            totalLocations: 45,
            favoriteCategory: .coffee,
            friendsCount: 23,
            followersCount: 156,
            followingCount: 89
        )
    }
}





