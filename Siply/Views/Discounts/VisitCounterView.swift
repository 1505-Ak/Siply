//
//  VisitCounterView.swift
//  Siply
//
//  Shows venues with visit/punch card programs
//

import SwiftUI

struct VisitCounterView: View {
    @EnvironmentObject var venueManager: VenueManager
    @State private var searchText = ""
    
    var venues: [Venue] {
        venueManager.getVenuesWithVisitCard()
    }
    
    var body: some View {
        ZStack {
            Color.siplyBackground.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    customHeader
                    
                    VStack(spacing: 16) {
                        searchBar
                        
                        ForEach(venues) { venue in
                            NavigationLink(destination: VisitCounterCardDetailView(venue: venue)) {
                                VisitCounterVenueCard(venue: venue)
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
                
                Text("Visit Counter Cards")
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
            
            TextField("Search...", text: $searchText)
                .font(.custom("TrebuchetMS", size: 15))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.siplyCardBackground)
        .cornerRadius(14)
    }
}

// MARK: - Visit Counter Venue Card

struct VisitCounterVenueCard: View {
    let venue: Venue
    
    var progress: Double {
        let goal = Double(venue.loyaltyProgram?.visitCardGoal ?? 10)
        let visits = Double(venue.visitCount)
        return min(visits / goal, 1.0)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(venue.imageIcon)
                    .font(.system(size: 32))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(venue.name)
                        .font(.custom("TrebuchetMS-Bold", size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("\(venue.visitCount)/\(venue.loyaltyProgram?.visitCardGoal ?? 10) visits")
                        .font(.custom("TrebuchetMS", size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: [.siplyMagenta, .siplyJade],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress)
                }
            }
            .frame(height: 8)
        }
        .padding()
        .background(Color.siplyCardBackground)
        .cornerRadius(16)
    }
}

// MARK: - Visit Counter Card Detail View (Punch Card Interface)

struct VisitCounterCardDetailView: View {
    @EnvironmentObject var venueManager: VenueManager
    let venue: Venue
    @State private var showConfetti = false
    
    var visitGoal: Int {
        venue.loyaltyProgram?.visitCardGoal ?? 10
    }
    
    var body: some View {
        ZStack {
            Color.siplyBackground.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    customHeader
                    
                    VStack(spacing: 30) {
                        // Venue Info
                        venueInfoSection
                        
                        // Punch Card
                        punchCardSection
                        
                        // Reward Info
                        rewardInfoSection
                        
                        // Action Button
                        stampButton
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
                
                Text("Visit Counter Card")
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
    
    private var venueInfoSection: some View {
        HStack(spacing: 16) {
            Text(venue.imageIcon)
                .font(.system(size: 60))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(venue.name)
                    .font(.custom("TrebuchetMS-Bold", size: 26))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(venue.location.city)
                    .font(.custom("TrebuchetMS", size: 15))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
    
    private var punchCardSection: some View {
        VStack(spacing: 20) {
            // Progress text
            HStack {
                Text("\(venue.visitCount) of \(visitGoal) visits")
                    .font(.custom("TrebuchetMS-Bold", size: 18))
                    .foregroundColor(.white)
                
                Spacer()
                
                if venue.visitCount >= visitGoal {
                    Text("COMPLETED! 🎉")
                        .font(.custom("TrebuchetMS-Bold", size: 14))
                        .foregroundColor(.siplyJade)
                }
            }
            
            // Punch card grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: min(visitGoal, 4)), spacing: 16) {
                ForEach(0..<visitGoal, id: \.self) { index in
                    PunchCardCircle(
                        isFilled: index < venue.visitCount,
                        isCompleted: venue.visitCount >= visitGoal
                    )
                }
            }
            .padding(24)
            .background(Color.siplyCardBackground)
            .cornerRadius(20)
        }
    }
    
    private var rewardInfoSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "gift.fill")
                    .foregroundColor(.siplyMagenta)
                    .font(.title3)
                
                Text("Your Reward")
                    .font(.custom("TrebuchetMS-Bold", size: 18))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            Text("Get \(visitGoal) stamps and receive a free drink of your choice!")
                .font(.custom("TrebuchetMS", size: 15))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.siplyCardBackground)
        .cornerRadius(16)
    }
    
    private var stampButton: some View {
        Button(action: {
            venueManager.addVisit(to: venue.id, pointsEarned: 10)
            HapticManager.shared.impact(style: .medium)
            
            if venue.visitCount + 1 >= visitGoal {
                showConfetti = true
            }
        }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.title3)
                
                Text("Add Visit")
                    .font(.custom("TrebuchetMS-Bold", size: 18))
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [.siplyMagenta, .siplyJade],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
        }
    }
}

// MARK: - Punch Card Circle

struct PunchCardCircle: View {
    let isFilled: Bool
    let isCompleted: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(isFilled ? Color.siplyJade : Color.gray.opacity(0.3))
                .frame(width: 50, height: 50)
            
            if isFilled {
                Image(systemName: "checkmark")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            } else {
                Circle()
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(width: 50, height: 50)
            }
        }
        .scaleEffect(isFilled ? 1.0 : 0.9)
        .animation(.spring(response: 0.3), value: isFilled)
    }
}

#Preview {
    NavigationView {
        VisitCounterView()
            .environmentObject(VenueManager())
    }
}

