//
//  HomeView.swift
//  Siply
//
//  V3 - Clean & Simple Homepage
//

import SwiftUI
import Combine

struct HomeView: View {
    @EnvironmentObject var drinkManager: DrinkManager
    @EnvironmentObject var achievementManager: AchievementManager
    @EnvironmentObject var venueManager: VenueManager
    @State private var friendPosts: [FriendPost] = FriendPost.samplePosts
    @State private var feedDrinks: [APIDrink] = []
    @State private var isLoadingFeed = false
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.siplyBackground.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Custom header
                        customHeader
                        
                        // Content
                        VStack(spacing: 20) {
                            // Discover & Trending Row
                            discoverTrendingRow
                            
                            // Friends Posts
                            friendsPostsSection
                            
                            // Categories
                            categoriesSection
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                fetchFeed()
            }
        }
    }
    
    private func fetchFeed() {
        isLoadingFeed = true
        
        APIClient.shared.getFeed(limit: 20)
            .sink { completion in
                isLoadingFeed = false
                if case .failure(let error) = completion {
                    print("Failed to fetch feed: \(error)")
                }
            } receiveValue: { response in
                feedDrinks = response.feed
            }
            .store(in: &cancellables)
    }
    
    private var customHeader: some View {
        VStack(spacing: 0) {
            // Coffee brown ribbon
            Rectangle()
                .fill(Color.siplyLightBrown)
                .frame(height: 4)
            
            HStack(spacing: 16) {
                SiplyLogo(size: 36, animated: true)
                
                Spacer()
                
                NavigationLink(destination: AchievementsView()) {
                    ZStack {
                        Circle()
                            .fill(Color.siplyLightBrown.opacity(0.3))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "bell.fill")
                            .foregroundColor(.siplyJade)
                            .font(.system(size: 18))
                        
                        Circle()
                            .fill(Color.siplyMagenta)
                            .frame(width: 10, height: 10)
                            .offset(x: 12, y: -12)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.siplyBackground)
        }
    }
    
    // MARK: - Discover & Trending Row
    
    private var discoverTrendingRow: some View {
        HStack(alignment: .top, spacing: 10) {
            // Discover - Show real venues
            NavigationLink(destination: DiscountsLandingView()) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Discover")
                        .font(.custom("TrebuchetMS-Bold", size: 14))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 6) {
                        ForEach(venueManager.venues.prefix(3)) { venue in
                            MiniPlaceRow(
                                icon: venue.imageIcon,
                                name: venue.name
                            )
                        }
                    }
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 150)
                .background(Color.siplyCardBackground)
                .cornerRadius(12)
            }
            .buttonStyle(.plain)
            
            // Trending
            VStack(alignment: .leading, spacing: 8) {
                Text("Trending Now")
                    .font(.custom("TrebuchetMS-Bold", size: 14))
                    .foregroundColor(.white)
                
                VStack(spacing: 6) {
                    ForEach(drinkManager.getTrendingDrinks(limit: 3)) { drink in
                        MiniDrinkRow(
                            icon: drink.category.icon,
                            name: drink.name,
                            rating: Int(drink.rating)
                        )
                    }
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 150)
            .background(Color.siplyCardBackground)
            .cornerRadius(12)
        }
    }
    
    // MARK: - Friends Posts Section
    
    private var friendsPostsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.siplyJade)
                    
                    Text("Friends")
                        .font(.custom("TrebuchetMS-Bold", size: 18))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                NavigationLink(destination: JournalView()) {
                    Text("See All")
                        .font(.custom("TrebuchetMS", size: 13))
                        .foregroundColor(.siplyJade)
                }
            }
            
            // Vertical list of posts
            ForEach(friendPosts.prefix(2)) { post in
                FriendPostCard(post: post)
            }
        }
    }
    
    // MARK: - Categories Section
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Categories")
                .font(.custom("TrebuchetMS-Bold", size: 18))
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(DrinkCategory.allCases, id: \.self) { category in
                        NavigationLink(destination: FilteredJournalView(category: category)) {
                            CategoryButton(category: category)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

// MARK: - Mini Place Row

struct MiniPlaceRow: View {
    let icon: String
    let name: String
    
    var body: some View {
        HStack(spacing: 6) {
            Text(icon)
                .font(.system(size: 16))
            
            Text(name)
                .font(.custom("TrebuchetMS", size: 11))
                .foregroundColor(.white)
                .lineLimit(1)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 8))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(Color.siplyBackground.opacity(0.5))
        .cornerRadius(8)
    }
}

// MARK: - Mini Drink Row

struct MiniDrinkRow: View {
    let icon: String
    let name: String
    let rating: Int
    
    var body: some View {
        HStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.siplyJade.opacity(0.2))
                    .frame(width: 26, height: 26)
                
                Text(icon)
                    .font(.system(size: 14))
            }
            
            VStack(alignment: .leading, spacing: 1) {
                Text(name)
                    .font(.custom("TrebuchetMS-Bold", size: 11))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                HStack(spacing: 1) {
                    ForEach(0..<rating, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: 7))
                            .foregroundColor(.siplyJade)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(Color.siplyBackground.opacity(0.5))
        .cornerRadius(8)
    }
}

// MARK: - Category Button

struct CategoryButton: View {
    let category: DrinkCategory
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.siplyCardBackground)
                    .frame(width: 64, height: 64)
                
                Text(category.icon)
                    .font(.system(size: 32))
            }
            
            Text(category.rawValue)
                .font(.custom("TrebuchetMS", size: 11))
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .frame(width: 70)
    }
}

#Preview {
    HomeView()
        .environmentObject(DrinkManager())
        .environmentObject(AchievementManager())
}
