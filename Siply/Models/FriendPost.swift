//
//  FriendPost.swift
//  Siply
//
//  Created on October 4, 2025.
//

import Foundation

struct FriendPost: Identifiable, Codable {
    var id = UUID()
    var userId: String
    var username: String
    var userDisplayName: String
    var drink: Drink
    var postedAt: Date
    var isTagged: Bool // True if user was tagged in this post
    
    init(userId: String, username: String, userDisplayName: String, drink: Drink, postedAt: Date = Date(), isTagged: Bool = false) {
        self.userId = userId
        self.username = username
        self.userDisplayName = userDisplayName
        self.drink = drink
        self.postedAt = postedAt
        self.isTagged = isTagged
    }
}

extension FriendPost {
    static let samplePosts: [FriendPost] = [
        FriendPost(
            userId: "user2",
            username: "cocktailfan",
            userDisplayName: "Mike Johnson",
            drink: Drink.sampleDrinks[0],
            postedAt: Date().addingTimeInterval(-1800),
            isTagged: true
        ),
        FriendPost(
            userId: "user1",
            username: "coffeelover",
            userDisplayName: "Sarah Chen",
            drink: Drink.sampleDrinks[1],
            postedAt: Date().addingTimeInterval(-5400)
        ),
        FriendPost(
            userId: "user3",
            username: "bobatea_addict",
            userDisplayName: "Emma Wilson",
            drink: Drink.sampleDrinks[2],
            postedAt: Date().addingTimeInterval(-14400)
        )
    ]
}
