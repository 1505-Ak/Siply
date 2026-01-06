//
//  FriendPostCard.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI

struct FriendPostCard: View {
    let post: FriendPost
    @State private var isLiked = false
    @State private var showComments = false
    @State private var newCommentText = ""
    @State private var imageScale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 0) {
            // User header (compact)
            HStack(spacing: 10) {
                // User avatar
                ZStack {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [Color.siplyJade, Color.siplyMagenta],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 36, height: 36)
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.siplyMagenta.opacity(0.8), Color.siplyJade.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 32, height: 32)
                        .overlay(
                            Text(String(post.userDisplayName.prefix(1)))
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        )
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(post.userDisplayName)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        if post.isTagged {
                            HStack(spacing: 3) {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 8))
                                Text("You")
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.siplyJade)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.siplyJade.opacity(0.2))
                            .cornerRadius(6)
                        }
                    }
                    
                    HStack(spacing: 3) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 9))
                            .foregroundColor(.gray)
                        Text(post.drink.locationName.components(separatedBy: ",").first ?? post.drink.locationName)
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                        Text("•")
                            .foregroundColor(.gray)
                            .font(.caption2)
                        Text(timeAgoString(from: post.postedAt))
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(90))
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            
            // Drink image (smaller)
            NavigationLink(destination: DrinkDetailView(drink: post.drink)) {
                Group {
                    if let imageData = post.drink.imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 160)
                            .clipped()
                    } else {
                        ZStack {
                            LinearGradient(
                                colors: [
                                    Color.siplyMagenta.opacity(0.3),
                                    Color.siplyJade.opacity(0.3)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            
                            VStack(spacing: 8) {
                                Image(systemName: categoryIcon(for: post.drink.category))
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                                
                                Text(post.drink.category.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(height: 160)
                    }
                }
                .scaleEffect(imageScale)
                .onTapGesture(count: 2) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        isLiked = true
                        imageScale = 0.95
                        HapticManager.shared.impact(style: .medium)
                    }
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5).delay(0.1)) {
                        imageScale = 1.0
                    }
                }
            }
            
            // Action buttons (compact)
            HStack(spacing: 14) {
                // Like button
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isLiked.toggle()
                        HapticManager.shared.impact(style: .light)
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .font(.system(size: 18))
                            .foregroundColor(isLiked ? .siplyMagenta : .white)
                            .scaleEffect(isLiked ? 1.1 : 1.0)
                        
                        Text("\(post.drink.likes + (isLiked ? 1 : 0))")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                }
                
                // Comment button
                Button(action: { showComments = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.right")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                        
                        Text("12")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                }
                
                // Share button
                Button(action: {}) {
                    Image(systemName: "paperplane")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Save button
                Button(action: {}) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .sheet(isPresented: $showComments) {
                CommentsSheet(post: post, isPresented: $showComments, newCommentText: $newCommentText)
            }
            
            // Drink info section (minimal)
            VStack(alignment: .leading, spacing: 4) {
                // Rating and name in one line
                HStack(spacing: 6) {
                    HStack(spacing: 2) {
                        ForEach(0..<Int(post.drink.rating), id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(.siplyJade)
                                .font(.system(size: 8))
                        }
                        Text(String(format: "%.1f", post.drink.rating))
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.siplyJade)
                    }
                    
                    Spacer()
                }
                
                // Drink name
                Text(post.drink.name)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                // Category and price
                HStack(spacing: 6) {
                    Text(post.drink.category.rawValue)
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                    if let price = post.drink.price {
                        Text("•")
                            .foregroundColor(.gray)
                            .font(.caption2)
                        Text("$\(String(format: "%.0f", price))")
                            .font(.caption2)
                            .foregroundColor(.siplyLightBrown)
                    }
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.siplyCardBackground.opacity(0.8))
        }
        .background(Color.siplyCardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(post.isTagged ? Color.siplyJade.opacity(0.4) : Color.clear, lineWidth: 2)
        )
        .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
    }
    
    private func categoryIcon(for category: DrinkCategory) -> String {
        switch category {
        case .cocktail: return "wineglass"
        case .mocktail: return "sparkles"
        case .coffee: return "cup.and.saucer.fill"
        case .bubbleTea: return "drop.fill"
        case .craftBeer: return "mug.fill"
        case .wine: return "wineglass.fill"
        case .smoothie: return "leaf.fill"
        case .juice: return "drop.triangle.fill"
        case .tea: return "leaf"
        case .soda: return "bubbles.and.sparkles"
        case .other: return "cup.and.saucer"
        }
    }
    
    private func timeAgoString(from date: Date) -> String {
        let seconds = Date().timeIntervalSince(date)
        
        if seconds < 60 {
            return "just now"
        } else if seconds < 3600 {
            let minutes = Int(seconds / 60)
            return "\(minutes)m ago"
        } else if seconds < 86400 {
            let hours = Int(seconds / 3600)
            return "\(hours)h ago"
        } else {
            let days = Int(seconds / 86400)
            return "\(days)d ago"
        }
    }
}

// MARK: - Comments Sheet

struct CommentsSheet: View {
    let post: FriendPost
    @Binding var isPresented: Bool
    @Binding var newCommentText: String
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.siplyBackground.ignoresSafeArea()
                VStack(alignment: .leading, spacing: 16) {
                    Text("Comments")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    if post.comments.isEmpty {
                        Text("No comments yet. Be the first to comment!")
                            .foregroundColor(.gray)
                    } else {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(post.comments, id: \.self) { comment in
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(comment.author)
                                            .font(.headline)
                                            .foregroundColor(.siplyJade)
                                        Text(comment.text)
                                            .foregroundColor(.white)
                                        Text(comment.timestamp, style: .time)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color.siplyCardBackground)
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                    
                    // Add comment field
                    HStack(spacing: 12) {
                        TextField("Add a comment...", text: $newCommentText, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .foregroundColor(.white)
                            .lineLimit(1...3)
                        
                        Button(action: {
                            // TODO: connect to backend; for now, clear and close
                            newCommentText = ""
                            isPresented = false
                        }) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.siplyJade)
                                .padding(10)
                                .background(Color.siplyCardBackground)
                                .clipShape(Circle())
                        }
                        .disabled(newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .padding(.vertical, 8)
                    
                    Spacer()
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { isPresented = false }
                        .foregroundColor(.siplyJade)
                }
            }
        }
    }
}
