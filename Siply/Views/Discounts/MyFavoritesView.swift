//
//  MyFavoritesView.swift
//  Siply
//
//  Shows user's favorited/hearted venues
//

import SwiftUI

struct MyFavoritesView: View {
    @EnvironmentObject var venueManager: VenueManager
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            Color.siplyBackground.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    customHeader
                    
                    VStack(spacing: 16) {
                        searchBar
                        
                        if venueManager.favoriteVenues.isEmpty {
                            emptyState
                        } else {
                            ForEach(venueManager.favoriteVenues) { venue in
                                FavoriteVenueCard(venue: venue)
                            }
                        }
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
                
                Text("My Favorites")
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
            
            TextField("Search favorites...", text: $searchText)
                .font(.custom("TrebuchetMS", size: 15))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.siplyCardBackground)
        .cornerRadius(14)
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.slash")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No favorites yet")
                .font(.custom("TrebuchetMS-Bold", size: 18))
                .foregroundColor(.white)
            
            Text("Heart venues to add them to your favorites")
                .font(.custom("TrebuchetMS", size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

// MARK: - Favorite Venue Card

struct FavoriteVenueCard: View {
    @EnvironmentObject var venueManager: VenueManager
    let venue: Venue
    
    var body: some View {
        HStack(spacing: 16) {
            Text(venue.imageIcon)
                .font(.system(size: 44))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(venue.name)
                    .font(.custom("TrebuchetMS-Bold", size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(venue.location.city)
                    .font(.custom("TrebuchetMS", size: 14))
                    .foregroundColor(.gray)
                
                // Quick info
                HStack(spacing: 12) {
                    if venue.hasStudentDiscount {
                        Label("Student", systemImage: "graduationcap.fill")
                            .font(.custom("TrebuchetMS", size: 11))
                            .foregroundColor(.siplyJade)
                    }
                    
                    if venue.hasHappyHour {
                        Label("Happy Hour", systemImage: "sun.max.fill")
                            .font(.custom("TrebuchetMS", size: 11))
                            .foregroundColor(.orange)
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                venueManager.toggleFavorite(venueId: venue.id)
                HapticManager.shared.impact(style: .light)
            }) {
                Image(systemName: venue.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 22))
                    .foregroundColor(.siplyMagenta)
            }
        }
        .padding()
        .background(Color.siplyCardBackground)
        .cornerRadius(16)
    }
}

#Preview {
    NavigationView {
        MyFavoritesView()
            .environmentObject(VenueManager())
    }
}

