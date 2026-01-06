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
    var comments: [PostComment]
    
    init(userId: String, username: String, userDisplayName: String, drink: Drink, postedAt: Date = Date(), isTagged: Bool = false, comments: [PostComment] = []) {
        self.userId = userId
        self.username = username
        self.userDisplayName = userDisplayName
        self.drink = drink
        self.postedAt = postedAt
        self.isTagged = isTagged
        self.comments = comments
    }
}

struct PostComment: Identifiable, Codable, Hashable {
    var id = UUID()
    var author: String
    var text: String
    var timestamp: Date
}

extension FriendPost {
    static let samplePosts: [FriendPost] = [
        FriendPost(
            userId: "user2",
            username: "cocktailfan",
            userDisplayName: "Mike Johnson",
            drink: Drink.sampleDrinks[0],
            postedAt: Date().addingTimeInterval(-1800),
            isTagged: true,
            comments: [
                PostComment(author: "Jess", text: "Looks amazing!", timestamp: Date().addingTimeInterval(-600)),
                PostComment(author: "Leo", text: "Need to try this place.", timestamp: Date().addingTimeInterval(-400))
            ]
        ),
        FriendPost(
            userId: "user1",
            username: "coffeelover",
            userDisplayName: "Sarah Chen",
            drink: Drink.sampleDrinks[1],
            postedAt: Date().addingTimeInterval(-5400),
            comments: [
                PostComment(author: "Alex", text: "Matcha heaven.", timestamp: Date().addingTimeInterval(-2000))
            ]
        ),
        FriendPost(
            userId: "user3",
            username: "bobatea_addict",
            userDisplayName: "Emma Wilson",
            drink: Drink.sampleDrinks[2],
            postedAt: Date().addingTimeInterval(-14400),
            comments: []
        )
    ]
}
