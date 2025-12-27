//
//  JournalView.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI

struct JournalView: View {
    @EnvironmentObject var drinkManager: DrinkManager
    @State private var searchText = ""
    @State private var showingFilterSheet = false
    @State private var showingPersonalMap = false
    @State private var sortOption: SortOption = .dateNewest
    
    enum SortOption: String, CaseIterable {
        case dateNewest = "Date (Newest)"
        case dateOldest = "Date (Oldest)"
        case ratingHighest = "Rating (Highest)"
        case ratingLowest = "Rating (Lowest)"
        case name = "Name (A-Z)"
    }
    
    var sortedDrinks: [Drink] {
        let filtered = searchText.isEmpty ? drinkManager.drinks : drinkManager.drinks.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.locationName.localizedCaseInsensitiveContains(searchText)
        }
        
        switch sortOption {
        case .dateNewest:
            return filtered.sorted { $0.date > $1.date }
        case .dateOldest:
            return filtered.sorted { $0.date < $1.date }
        case .ratingHighest:
            return filtered.sorted { $0.rating > $1.rating }
        case .ratingLowest:
            return filtered.sorted { $0.rating < $1.rating }
        case .name:
            return filtered.sorted { $0.name < $1.name }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.siplyBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom header
                    customJournalHeader
                    
                    // Search Bar - Professional Design
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.siplyJade)
                            .font(.system(size: 16))
                        
                        TextField("Search by name or location...", text: $searchText)
                            .foregroundColor(.white)
                            .autocorrectionDisabled()
                        
                        if !searchText.isEmpty {
                            Button(action: { 
                                searchText = ""
                                HapticManager.shared.selection()
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color.siplyCardBackground)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Stats Bar
                    statsBar
                    
                    // Drinks List
                    if sortedDrinks.isEmpty {
                        emptyState
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(sortedDrinks) { drink in
                                    NavigationLink(destination: DrinkDetailView(drink: drink)) {
                                        JournalDrinkCard(drink: drink)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingPersonalMap) {
                PersonalMapView()
            }
        }
    }
    
    private var customJournalHeader: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.black)
                .frame(height: 1)
            
            HStack {
                Text("Journal")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack(spacing: 12) {
                    // Map button with professional styling
                    Button(action: { 
                        HapticManager.shared.selection()
                        showingPersonalMap = true
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "map.fill")
                                .font(.system(size: 14))
                            Text("Map")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.siplyCharcoal)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.siplyJade)
                        .cornerRadius(20)
                    }
                    .buttonStyle(.plain)
                    
                    // Sort menu
                    Menu {
                        Picker("Sort By", selection: $sortOption) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Label(option.rawValue, systemImage: sortIcon(for: option))
                                    .tag(option)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle.fill")
                            .foregroundColor(.siplyJade)
                            .font(.title3)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color.siplyBackground)
        }
    }
    
    private func sortIcon(for option: SortOption) -> String {
        switch option {
        case .dateNewest: return "calendar.badge.clock"
        case .dateOldest: return "calendar"
        case .ratingHighest: return "star.fill"
        case .ratingLowest: return "star"
        case .name: return "textformat.abc"
        }
    }
    
    private var statsBar: some View {
        HStack(spacing: 16) {
            ProfessionalStatItem(
                title: "Total Drinks",
                value: "\(drinkManager.getTotalDrinks())",
                icon: "drop.fill",
                color: .siplyJade
            )
            
            ProfessionalStatItem(
                title: "Places",
                value: "\(drinkManager.getTotalLocations())",
                icon: "mappin.circle.fill",
                color: .siplyLightBrown
            )
            
            ProfessionalStatItem(
                title: "Avg Rating",
                value: String(format: "%.1f", drinkManager.getAverageRating()),
                icon: "star.fill",
                color: .siplyMagenta
            )
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private var emptyState: some View {
        VStack(spacing: 24) {
            Image(systemName: "book.closed")
                .font(.system(size: 70))
                .foregroundColor(.gray.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("Your Journal is Empty")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Start logging drinks to build your\npersonal collection and view them on your map!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            NavigationLink(destination: AddDrinkView()) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                    Text("Log Your First Drink")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.siplyCharcoal)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.siplyJade)
                .cornerRadius(25)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

struct StatItem: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.caption)
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
            Text(title)
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

// Professional stat item with better design
struct ProfessionalStatItem: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 14))
                
                Text(value)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.siplyCardBackground)
        .cornerRadius(12)
    }
}

struct JournalDrinkCard: View {
    let drink: Drink
    @EnvironmentObject var drinkManager: DrinkManager
    @State private var offset: CGFloat = 0
    @State private var isSwiped = false
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // Background actions
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        drinkManager.toggleFavorite(drink)
                        HapticManager.shared.impact(style: .medium)
                    }
                }) {
                    VStack {
                        Image(systemName: drink.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(.white)
                            .font(.title2)
                        Text(drink.isFavorite ? "Unfavorite" : "Favorite")
                            .font(.caption2)
                            .foregroundColor(.white)
                    }
                    .frame(width: 80)
                    .padding()
                }
                .background(Color.siplyMagenta)
            }
            .cornerRadius(12)
            
            // Main card
            content
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if gesture.translation.width < 0 {
                                offset = gesture.translation.width
                            }
                        }
                        .onEnded { gesture in
                            withAnimation(.spring()) {
                                if gesture.translation.width < -50 {
                                    offset = -80
                                    isSwiped = true
                                } else {
                                    offset = 0
                                    isSwiped = false
                                }
                            }
                        }
                )
        }
    }
    
    private var content: some View {
        HStack(spacing: 12) {
            // Photo or Category Icon
            Group {
                if let imageData = drink.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipped()
                        .cornerRadius(8)
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.siplyMagenta.opacity(0.3))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Text(drink.category.icon)
                                .font(.title)
                        )
                }
            }
            
            // Drink Info
            VStack(alignment: .leading, spacing: 4) {
                Text(drink.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack {
                    ForEach(0..<5) { index in
                        Image(systemName: Double(index) < drink.rating ? "star.fill" : "star")
                            .foregroundColor(.siplyJade)
                            .font(.caption)
                    }
                    Text(String(format: "%.1f", drink.rating))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.siplyLightBrown)
                        .font(.caption)
                    Text(drink.locationName)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                Text(drink.date, style: .date)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Favorite Button
            Button(action: {
                drinkManager.toggleFavorite(drink)
            }) {
                Image(systemName: drink.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(drink.isFavorite ? .siplyMagenta : .gray)
                    .font(.title3)
            }
        }
        .padding()
        .background(Color.siplyCardBackground)
        .cornerRadius(12)
    }
}

#Preview {
    JournalView()
        .environmentObject(DrinkManager())
}
