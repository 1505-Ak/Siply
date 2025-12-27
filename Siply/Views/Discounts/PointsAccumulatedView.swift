//
//  PointsAccumulatedView.swift
//  Siply
//
//  Shows points accumulated per venue with available offers
//

import SwiftUI

struct PointsAccumulatedView: View {
    @EnvironmentObject var venueManager: VenueManager
    @State private var searchText = ""
    @State private var filterOption: FilterOption = .all
    
    enum FilterOption: String, CaseIterable {
        case all = "All"
        case withOffers = "With Offers"
        case highPoints = "High Points"
    }
    
    var filteredVenues: [Venue] {
        var venues = venueManager.venues.filter { $0.pointsEarned > 0 }
        
        switch filterOption {
        case .all:
            break
        case .withOffers:
            venues = venues.filter { venueManager.getAvailableOffersCount(for: $0.id) > 0 }
        case .highPoints:
            venues = venues.filter { $0.pointsEarned >= 100 }
        }
        
        return venues.sorted { $0.pointsEarned > $1.pointsEarned }
    }
    
    var body: some View {
        ZStack {
            Color.siplyBackground.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    customHeader
                    
                    VStack(spacing: 16) {
                        // Search Bar
                        searchBar
                        
                        // Filter Options
                        filterSection
                        
                        // Venue List
                        if filteredVenues.isEmpty {
                            emptyState
                        } else {
                            ForEach(filteredVenues) { venue in
                                PointsVenueCard(venue: venue)
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
            
            HStack(spacing: 12) {
                NavigationBackButton()
                
                Text("Points")
                    .font(.custom("TrebuchetMS-Bold", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                // Total points badge
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 13))
                        .foregroundColor(.siplyJade)
                    Text("\(venueManager.getTotalPoints())")
                        .font(.custom("TrebuchetMS-Bold", size: 15))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.siplyCardBackground)
                .cornerRadius(20)
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
            
            TextField("Search...", text: $searchText)
                .font(.custom("TrebuchetMS", size: 15))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.siplyCardBackground)
        .cornerRadius(14)
    }
    
    private var filterSection: some View {
        HStack(spacing: 8) {
            ForEach(FilterOption.allCases, id: \.self) { option in
                Button(action: {
                    filterOption = option
                    HapticManager.shared.impact(style: .light)
                }) {
                    Text(option.rawValue)
                        .font(.custom("TrebuchetMS", size: 13))
                        .foregroundColor(filterOption == option ? .white : .gray)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(filterOption == option ? Color.siplyJade : Color.siplyCardBackground)
                        .cornerRadius(20)
                }
            }
            
            Spacer()
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "star.slash")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No points yet")
                .font(.custom("TrebuchetMS-Bold", size: 18))
                .foregroundColor(.white)
            
            Text("Start visiting venues to earn points")
                .font(.custom("TrebuchetMS", size: 14))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

// MARK: - Points Venue Card

struct PointsVenueCard: View {
    @EnvironmentObject var venueManager: VenueManager
    let venue: Venue
    
    var availableOffers: Int {
        venueManager.getAvailableOffersCount(for: venue.id)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Main content
            HStack(spacing: 16) {
                Text(venue.imageIcon)
                    .font(.system(size: 40))
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(venue.name)
                        .font(.custom("TrebuchetMS-Bold", size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 16) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.siplyJade)
                            Text("\(venue.pointsEarned)")
                                .font(.custom("TrebuchetMS-Bold", size: 14))
                                .foregroundColor(.siplyJade)
                        }
                        
                        if availableOffers > 0 {
                            HStack(spacing: 4) {
                                Image(systemName: "gift.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.siplyMagenta)
                                Text("\(availableOffers)")
                                    .font(.custom("TrebuchetMS-Bold", size: 14))
                                    .foregroundColor(.siplyMagenta)
                            }
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            
            // Offers section
            if availableOffers > 0 {
                Divider()
                    .background(Color.gray.opacity(0.3))
                
                HStack {
                    Image(systemName: "tag.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.siplyJade)
                    
                    Text("Offers Available: \(availableOffers)")
                        .font(.custom("TrebuchetMS", size: 13))
                        .foregroundColor(.siplyJade)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.siplyJade.opacity(0.1))
            }
        }
        .background(Color.siplyCardBackground)
        .cornerRadius(16)
    }
}

#Preview {
    NavigationView {
        PointsAccumulatedView()
            .environmentObject(VenueManager())
    }
}

