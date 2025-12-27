//
//  DiscountsView.swift
//  Siply
//
//  Shows featured discount categories
//

import SwiftUI

struct DiscountsView: View {
    @EnvironmentObject var venueManager: VenueManager
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            Color.siplyBackground.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header
                    customHeader
                    
                    VStack(spacing: 20) {
                        // Search Bar
                        searchBar
                        
                        // Featured Categories Grid
                        featuredSection
                    }
                    .padding()
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var customHeader: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.siplyLightBrown)
                .frame(height: 4)
            
            HStack(spacing: 16) {
                NavigationBackButton()
                
                Text("Discounts")
                    .font(.custom("TrebuchetMS-Bold", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.siplyBackground)
        }
    }
    
    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
                .foregroundColor(.gray)
            
            TextField("Search venues...", text: $searchText)
                .font(.custom("TrebuchetMS", size: 15))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.siplyCardBackground)
        .cornerRadius(14)
    }
    
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Featured")
                .font(.custom("TrebuchetMS-Bold", size: 22))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 14) {
                // Your Favorites
                NavigationLink(destination: MyFavoritesView()) {
                    FeaturedCategoryCard(
                        title: "Your\nFavorites",
                        icon: "heart.fill",
                        color: .siplyMagenta,
                        count: venueManager.favoriteVenues.count
                    )
                }
                
                // Near You
                NavigationLink(destination: NearYouView()) {
                    FeaturedCategoryCard(
                        title: "Near\nYou",
                        icon: "location.fill",
                        color: .siplyJade,
                        count: venueManager.getNearbyVenues().count
                    )
                }
                
                // Student Deals
                NavigationLink(destination: StudentDealsView()) {
                    FeaturedCategoryCard(
                        title: "Student\nDeals",
                        icon: "graduationcap.fill",
                        color: .siplyLightBrown,
                        count: venueManager.getStudentDiscountVenues().count
                    )
                }
                
                // Happy Hour
                NavigationLink(destination: HappyHourView()) {
                    FeaturedCategoryCard(
                        title: "Happy\nHour",
                        icon: "sun.max.fill",
                        color: Color.orange,
                        count: venueManager.getHappyHourVenues().count
                    )
                }
            }
        }
    }
}

// MARK: - Featured Category Card

struct FeaturedCategoryCard: View {
    let title: String
    let icon: String
    let color: Color
    let count: Int
    
    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.25))
                    .frame(width: 64, height: 64)
                
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.custom("TrebuchetMS-Bold", size: 15))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("\(count) places")
                    .font(.custom("TrebuchetMS", size: 11))
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .background(Color.siplyCardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)
    }
}

#Preview {
    NavigationView {
        DiscountsView()
            .environmentObject(VenueManager())
    }
}

