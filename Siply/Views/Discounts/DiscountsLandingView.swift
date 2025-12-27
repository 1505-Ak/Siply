//
//  DiscountsLandingView.swift
//  Siply
//
//  V3 - Polished Landing page for Discounts & Loyalty
//

import SwiftUI

struct DiscountsLandingView: View {
    @EnvironmentObject var venueManager: VenueManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.siplyBackground.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Coffee brown ribbon header
                        customHeader
                        
                        VStack(spacing: 24) {
                            // Hero Title
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Save more with Siply")
                                    .font(.custom("TrebuchetMS-Bold", size: 30))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("Unlock exclusive deals and earn rewards at your favorite spots")
                                    .font(.custom("TrebuchetMS", size: 15))
                                    .foregroundColor(.gray)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Main Navigation Cards
                            VStack(spacing: 16) {
                                // Discounts Card
                                NavigationLink(destination: DiscountsView()) {
                                    LandingCard(
                                        title: "Discounts",
                                        subtitle: "Find deals near you",
                                        icon: "tag.fill",
                                        gradient: [Color.siplyMagenta, Color.siplyMagenta.opacity(0.7)],
                                        stats: "\(venueManager.venues.filter { !$0.discounts.isEmpty || $0.hasHappyHour || $0.hasStudentDiscount }.count) venues with deals"
                                    )
                                }
                                
                                // Loyalty Schemes Card
                                NavigationLink(destination: LoyaltySchemesView()) {
                                    LandingCard(
                                        title: "Loyalty Schemes",
                                        subtitle: "Track your rewards",
                                        icon: "star.fill",
                                        gradient: [Color.siplyJade, Color.siplyJade.opacity(0.7)],
                                        stats: "\(venueManager.getVenuesWithLoyaltyPrograms().count) programs available"
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var customHeader: some View {
        VStack(spacing: 0) {
            // Coffee brown ribbon on top
            Rectangle()
                .fill(Color.siplyLightBrown)
                .frame(height: 4)
            
            HStack(spacing: 16) {
                Text("Deals")
                    .font(.custom("TrebuchetMS-Bold", size: 26))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                // Stats badge
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
}

// MARK: - Landing Card Component

struct LandingCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let gradient: [Color]
    let stats: String
    
    var body: some View {
        HStack(spacing: 18) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)
                
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.custom("TrebuchetMS-Bold", size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.custom("TrebuchetMS", size: 14))
                    .foregroundColor(.gray)
                
                Text(stats)
                    .font(.custom("TrebuchetMS", size: 12))
                    .foregroundColor(.siplyJade)
                    .padding(.top, 2)
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.gray)
        }
        .padding(20)
        .background(Color.siplyCardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    DiscountsLandingView()
        .environmentObject(VenueManager())
}

