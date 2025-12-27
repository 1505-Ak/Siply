//
//  LoyaltySchemeDetailViews.swift
//  Siply
//
//  Points Multiplier, Subscriptions, and Exclusive Offers Views
//

import SwiftUI

// MARK: - Points Multiplier View

struct PointsMultiplierView: View {
    @EnvironmentObject var venueManager: VenueManager
    @State private var searchText = ""
    
    var venues: [Venue] {
        venueManager.getVenuesWithMultiplier()
    }
    
    var body: some View {
        ZStack {
            Color.siplyBackground.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    CategoryHeader(title: "Points Multiplier", subtitle: "Earn bonus points faster")
                    
                    VStack(spacing: 16) {
                        CategorySearchBar(searchText: $searchText, placeholder: "Search...")
                        
                        ForEach(venues) { venue in
                            MultiplierVenueCard(venue: venue)
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

struct MultiplierVenueCard: View {
    let venue: Venue
    
    var multiplierRate: Double {
        venue.loyaltyProgram?.multiplierRate ?? 1.0
    }
    
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
                    
                    HStack(spacing: 4) {
                        Image(systemName: "multiply.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.siplyJade)
                        
                        Text("\(String(format: "%.1fx", multiplierRate)) points")
                            .font(.custom("TrebuchetMS-Bold", size: 14))
                            .foregroundColor(.siplyJade)
                    }
                }
                
                Spacer()
                
                // Multiplier badge
                Text("\(String(format: "%.0fx", multiplierRate))")
                    .font(.custom("TrebuchetMS-Bold", size: 20))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        LinearGradient(
                            colors: [.siplyJade, .siplyMagenta],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(12)
            }
            .padding()
            
            Divider().background(Color.gray.opacity(0.3))
            
            HStack {
                Text("Earn \(venue.loyaltyProgram?.pointsPerVisit ?? 10) points per visit with \(String(format: "%.0fx", multiplierRate)) multiplier")
                    .font(.custom("TrebuchetMS", size: 13))
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding()
        }
        .background(Color.siplyCardBackground)
        .cornerRadius(16)
    }
}

// MARK: - Subscriptions View

struct SubscriptionsView: View {
    @EnvironmentObject var venueManager: VenueManager
    @State private var searchText = ""
    
    var venues: [Venue] {
        venueManager.getVenuesWithSubscription()
    }
    
    var body: some View {
        ZStack {
            Color.siplyBackground.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    CategoryHeader(title: "Subscriptions", subtitle: "Monthly perks & unlimited drinks")
                    
                    VStack(spacing: 16) {
                        CategorySearchBar(searchText: $searchText, placeholder: "Search...")
                        
                        ForEach(venues) { venue in
                            SubscriptionVenueCard(venue: venue)
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

struct SubscriptionVenueCard: View {
    let venue: Venue
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [Color.orange.opacity(0.3), Color.orange.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "crown.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.orange)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(venue.name)
                        .font(.custom("TrebuchetMS-Bold", size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    if let details = venue.loyaltyProgram?.subscriptionDetails {
                        Text(details)
                            .font(.custom("TrebuchetMS", size: 13))
                            .foregroundColor(.gray)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
            }
            .padding()
            
            Divider().background(Color.gray.opacity(0.3))
            
            Button(action: {
                HapticManager.shared.impact(style: .medium)
            }) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16))
                    
                    Text("Subscribe")
                        .font(.custom("TrebuchetMS-Bold", size: 14))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.orange)
            }
        }
        .background(Color.siplyCardBackground)
        .cornerRadius(16)
    }
}

// MARK: - Exclusive Offers View

struct ExclusiveOffersView: View {
    @EnvironmentObject var venueManager: VenueManager
    @State private var searchText = ""
    
    var venues: [Venue] {
        venueManager.getVenuesWithExclusiveOffers()
    }
    
    var body: some View {
        ZStack {
            Color.siplyBackground.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    CategoryHeader(title: "Exclusive Member Offers", subtitle: "Special deals for loyalty members")
                    
                    VStack(spacing: 16) {
                        CategorySearchBar(searchText: $searchText, placeholder: "Search...")
                        
                        ForEach(venues) { venue in
                            ExclusiveOffersVenueCard(venue: venue)
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

struct ExclusiveOffersVenueCard: View {
    let venue: Venue
    
    var exclusiveOffers: [Discount] {
        venue.loyaltyProgram?.exclusiveOffers ?? []
    }
    
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
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.siplyLightBrown)
                        
                        Text("\(exclusiveOffers.count) exclusive offers")
                            .font(.custom("TrebuchetMS", size: 13))
                            .foregroundColor(.siplyLightBrown)
                    }
                }
                
                Spacer()
                
                Image(systemName: "lock.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.siplyLightBrown)
            }
            .padding()
            
            // Show offers
            if !exclusiveOffers.isEmpty {
                Divider().background(Color.gray.opacity(0.3))
                
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(exclusiveOffers) { offer in
                        HStack(spacing: 8) {
                            Image(systemName: "gift.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.siplyMagenta)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(offer.title)
                                    .font(.custom("TrebuchetMS-Bold", size: 13))
                                    .foregroundColor(.white)
                                
                                Text(offer.description)
                                    .font(.custom("TrebuchetMS", size: 11))
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
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

#Preview {
    NavigationView {
        PointsMultiplierView()
            .environmentObject(VenueManager())
    }
}


