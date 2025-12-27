//
//  CategoryViews.swift
//  Siply
//
//  Near You, Student Deals, and Happy Hour Views
//

import SwiftUI

// MARK: - Near You View

struct NearYouView: View {
    @EnvironmentObject var venueManager: VenueManager
    @State private var searchText = ""
    
    var venues: [Venue] {
        venueManager.getNearbyVenues()
    }
    
    var body: some View {
        ZStack {
            Color.siplyBackground.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    CategoryHeader(title: "Near You", subtitle: "Discounted drinks nearby")
                    
                    VStack(spacing: 16) {
                        CategorySearchBar(searchText: $searchText, placeholder: "Search nearby...")
                        
                        ForEach(venues) { venue in
                            DiscountVenueCard(venue: venue, showDistance: true)
                        }
                    }
                    .padding()
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Student Deals View

struct StudentDealsView: View {
    @EnvironmentObject var venueManager: VenueManager
    @State private var searchText = ""
    
    var venues: [Venue] {
        venueManager.getStudentDiscountVenues()
    }
    
    var body: some View {
        ZStack {
            Color.siplyBackground.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    CategoryHeader(title: "Student Deals", subtitle: "Save with your student ID")
                    
                    VStack(spacing: 16) {
                        CategorySearchBar(searchText: $searchText, placeholder: "Search student deals...")
                        
                        // Info banner
                        HStack(spacing: 10) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.siplyJade)
                            
                            Text("Show your valid student ID to claim these offers")
                                .font(.custom("TrebuchetMS", size: 13))
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.siplyJade.opacity(0.1))
                        .cornerRadius(12)
                        
                        ForEach(venues) { venue in
                            DiscountVenueCard(venue: venue, highlightStudentDeal: true)
                        }
                    }
                    .padding()
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Happy Hour View

struct HappyHourView: View {
    @EnvironmentObject var venueManager: VenueManager
    @State private var searchText = ""
    
    var venues: [Venue] {
        venueManager.getHappyHourVenues()
    }
    
    var body: some View {
        ZStack {
            Color.siplyBackground.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    CategoryHeader(title: "Happy Hour", subtitle: "Special deals on drinks")
                    
                    VStack(spacing: 16) {
                        CategorySearchBar(searchText: $searchText, placeholder: "Search happy hours...")
                        
                        ForEach(venues) { venue in
                            HappyHourVenueCard(venue: venue)
                        }
                    }
                    .padding()
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Shared Components

struct CategoryHeader: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.siplyLightBrown)
                .frame(height: 4)
            
            HStack(spacing: 16) {
                NavigationBackButton()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.custom("TrebuchetMS-Bold", size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.custom("TrebuchetMS", size: 13))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.siplyBackground)
        }
    }
}

struct CategorySearchBar: View {
    @Binding var searchText: String
    let placeholder: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $searchText)
                .font(.custom("TrebuchetMS", size: 15))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.siplyCardBackground)
        .cornerRadius(14)
    }
}

struct DiscountVenueCard: View {
    @EnvironmentObject var venueManager: VenueManager
    let venue: Venue
    var showDistance: Bool = false
    var highlightStudentDeal: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Text(venue.imageIcon)
                    .font(.system(size: 40))
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(venue.name)
                        .font(.custom("TrebuchetMS-Bold", size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(venue.location.address)
                        .font(.custom("TrebuchetMS", size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    
                    if showDistance {
                        Text("0.5 km away") // TODO: Calculate real distance
                            .font(.custom("TrebuchetMS", size: 12))
                            .foregroundColor(.siplyJade)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    venueManager.toggleFavorite(venueId: venue.id)
                    HapticManager.shared.impact(style: .light)
                }) {
                    Image(systemName: venue.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                        .foregroundColor(.siplyMagenta)
                }
            }
            .padding()
            
            // Discounts section
            if !venue.discounts.isEmpty {
                Divider().background(Color.gray.opacity(0.3))
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(venue.discounts.prefix(2)) { discount in
                        HStack(spacing: 8) {
                            Image(systemName: "tag.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.siplyMagenta)
                            
                            Text(discount.title)
                                .font(.custom("TrebuchetMS", size: 13))
                                .foregroundColor(.white)
                            
                            if let percentage = discount.discountPercentage {
                                Text("\(percentage)% off")
                                    .font(.custom("TrebuchetMS-Bold", size: 12))
                                    .foregroundColor(.siplyJade)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.siplyJade.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.siplyCardBackground.opacity(0.5))
            }
        }
        .background(Color.siplyCardBackground)
        .cornerRadius(16)
    }
}

struct HappyHourVenueCard: View {
    @EnvironmentObject var venueManager: VenueManager
    let venue: Venue
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Text(venue.imageIcon)
                    .font(.system(size: 40))
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(venue.name)
                        .font(.custom("TrebuchetMS-Bold", size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    if let happyHour = venue.happyHourDetails {
                        HStack(spacing: 4) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.orange)
                            
                            Text("\(happyHour.startTime) - \(happyHour.endTime)")
                                .font(.custom("TrebuchetMS", size: 13))
                                .foregroundColor(.orange)
                        }
                        
                        Text(happyHour.days.prefix(3).joined(separator: ", "))
                            .font(.custom("TrebuchetMS", size: 12))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    venueManager.toggleFavorite(venueId: venue.id)
                    HapticManager.shared.impact(style: .light)
                }) {
                    Image(systemName: venue.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                        .foregroundColor(.siplyMagenta)
                }
            }
            .padding()
            
            // Happy Hour Deal
            if let happyHour = venue.happyHourDetails {
                Divider().background(Color.gray.opacity(0.3))
                
                HStack {
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.orange)
                    
                    Text(happyHour.discount)
                        .font(.custom("TrebuchetMS-Bold", size: 14))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color.orange.opacity(0.2), Color.orange.opacity(0.1)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            }
        }
        .background(Color.siplyCardBackground)
        .cornerRadius(16)
    }
}

#Preview {
    NavigationView {
        NearYouView()
            .environmentObject(VenueManager())
    }
}

