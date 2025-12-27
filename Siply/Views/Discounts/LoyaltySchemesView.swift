//
//  LoyaltySchemesView.swift
//  Siply
//
//  Shows 4 types of loyalty programs
//

import SwiftUI

struct LoyaltySchemesView: View {
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
                        
                        // Loyalty Scheme Cards
                        loyaltyCardsSection
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
                
                Text("Loyalty Schemes")
                    .font(.custom("TrebuchetMS-Bold", size: 22))
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
            
            TextField("Search programs...", text: $searchText)
                .font(.custom("TrebuchetMS", size: 15))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.siplyCardBackground)
        .cornerRadius(14)
    }
    
    private var loyaltyCardsSection: some View {
        VStack(spacing: 16) {
            // Points Multiplier
            NavigationLink(destination: PointsMultiplierView()) {
                LoyaltySchemeCard(
                    title: "Points Multiplier",
                    subtitle: "Earn bonus points",
                    icon: "multiply.circle.fill",
                    color: .siplyJade,
                    count: venueManager.getVenuesWithMultiplier().count
                )
            }
            
            // Subscriptions
            NavigationLink(destination: SubscriptionsView()) {
                LoyaltySchemeCard(
                    title: "Subscriptions",
                    subtitle: "Monthly perks & savings",
                    icon: "crown.fill",
                    color: Color.orange,
                    count: venueManager.getVenuesWithSubscription().count
                )
            }
            
            // Visit Counter Card
            NavigationLink(destination: VisitCounterView()) {
                LoyaltySchemeCard(
                    title: "Visit Counter Card",
                    subtitle: "Collect stamps for rewards",
                    icon: "circle.grid.3x3.fill",
                    color: .siplyMagenta,
                    count: venueManager.getVenuesWithVisitCard().count
                )
            }
            
            // Exclusive Member Offers
            NavigationLink(destination: ExclusiveOffersView()) {
                LoyaltySchemeCard(
                    title: "Exclusive Member Offers",
                    subtitle: "Special deals for members",
                    icon: "star.fill",
                    color: .siplyLightBrown,
                    count: venueManager.getVenuesWithExclusiveOffers().count
                )
            }
        }
    }
}

// MARK: - Loyalty Scheme Card

struct LoyaltySchemeCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let count: Int
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(color.opacity(0.25))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 26))
                    .foregroundColor(color)
            }
            
            // Text
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.custom("TrebuchetMS-Bold", size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(subtitle)
                    .font(.custom("TrebuchetMS", size: 13))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Count badge and chevron
            VStack(spacing: 6) {
                Text("\(count)")
                    .font(.custom("TrebuchetMS-Bold", size: 18))
                    .foregroundColor(.siplyJade)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.gray)
            }
        }
        .padding(18)
        .background(Color.siplyCardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)
    }
}

#Preview {
    NavigationView {
        LoyaltySchemesView()
            .environmentObject(VenueManager())
    }
}

