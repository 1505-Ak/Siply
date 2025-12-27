//
//  PersonalMapView.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI
import MapKit
import CoreLocation

struct PersonalMapView: View {
    @EnvironmentObject var drinkManager: DrinkManager
    @Environment(\.dismiss) var dismiss
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278),
        span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
    )
    @State private var selectedDrink: Drink?
    @State private var showStats = true
    
    var body: some View {
        NavigationView {
            ZStack {
                if drinksWithLocations.isEmpty {
                    // Empty state
                    emptyStateView
                } else {
                    // Map with drinks
                    Map(coordinateRegion: $region, annotationItems: drinksWithLocations) { drink in
                        MapAnnotation(coordinate: drink.coordinate!) {
                            PersonalMapMarker(drink: drink)
                                .onTapGesture {
                                    withAnimation {
                                        selectedDrink = drink
                                        HapticManager.shared.selection()
                                    }
                                }
                        }
                    }
                    .ignoresSafeArea()
                    
                    VStack {
                        // Stats overlay at top
                        if showStats {
                            statsOverlay
                                .transition(.move(edge: .top).combined(with: .opacity))
                        }
                        
                        Spacer()
                        
                        // Selected drink card at bottom
                        if let drink = selectedDrink {
                            PersonalDrinkCard(drink: drink, onClose: {
                                withAnimation {
                                    selectedDrink = nil
                                }
                            })
                            .padding()
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 12) {
                        Image(systemName: "map.fill")
                            .foregroundColor(.siplyJade)
                        Text("Your Journey")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.siplyJade)
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    centerMapOnDrinks()
                }
            }
        }
    }
    
    private var statsOverlay: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                MapStatPill(
                    icon: "drop.fill",
                    value: "\(drinksWithLocations.count)",
                    label: "Drinks Logged"
                )
                
                MapStatPill(
                    icon: "mappin.circle.fill",
                    value: "\(drinkManager.getTotalLocations())",
                    label: "Places Visited"
                )
            }
            
            // Category breakdown
            HStack(spacing: 8) {
                ForEach(getCategoryBreakdown().prefix(3), id: \.category) { item in
                    HStack(spacing: 4) {
                        Image(systemName: categoryIcon(item.category))
                            .font(.caption)
                        Text("\(item.count)")
                            .font(.caption2)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.siplyJade)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.siplyJade.opacity(0.15))
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.siplyCardBackground)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        )
        .padding()
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "map")
                .font(.system(size: 80))
                .foregroundColor(.gray)
            
            VStack(spacing: 8) {
                Text("No Drinks Mapped Yet")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Start logging drinks with locations\nto see your journey map!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { dismiss() }) {
                Text("Log Your First Drink")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.siplyCharcoal)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color.siplyJade)
                    .cornerRadius(25)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.siplyBackground)
    }
    
    private var drinksWithLocations: [Drink] {
        drinkManager.drinks.filter { $0.coordinate != nil }
    }
    
    private func centerMapOnDrinks() {
        guard !drinksWithLocations.isEmpty else { return }
        
        let coordinates = drinksWithLocations.compactMap { $0.coordinate }
        guard !coordinates.isEmpty else { return }
        
        let latitudes = coordinates.map { $0.latitude }
        let longitudes = coordinates.map { $0.longitude }
        
        guard let maxLat = latitudes.max(),
              let minLat = latitudes.min(),
              let maxLon = longitudes.max(),
              let minLon = longitudes.min() else { return }
        
        let center = CLLocationCoordinate2D(
            latitude: (maxLat + minLat) / 2,
            longitude: (maxLon + minLon) / 2
        )
        
        // Calculate span with reasonable bounds
        var latDelta = max((maxLat - minLat) * 1.5, 0.05)
        var lonDelta = max((maxLon - minLon) * 1.5, 0.05)
        
        // Clamp to reasonable maximum values
        latDelta = min(latDelta, 180.0)
        lonDelta = min(lonDelta, 180.0)
        
        // If drinks are too spread out, use a more zoomed-out view
        if latDelta > 90 || lonDelta > 90 {
            latDelta = 90
            lonDelta = 90
        }
        
        let span = MKCoordinateSpan(
            latitudeDelta: latDelta,
            longitudeDelta: lonDelta
        )
        
        withAnimation {
            region = MKCoordinateRegion(center: center, span: span)
        }
    }
    
    private func getCategoryBreakdown() -> [(category: DrinkCategory, count: Int)] {
        let categoryCounts = Dictionary(grouping: drinksWithLocations, by: { $0.category })
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }
            .map { (category: $0.key, count: $0.value) }
        return categoryCounts
    }
    
    private func categoryIcon(_ category: DrinkCategory) -> String {
        switch category {
        case .cocktail: return "wineglass.fill"
        case .mocktail: return "sparkles"
        case .coffee: return "cup.and.saucer.fill"
        case .bubbleTea: return "drop.fill"
        case .craftBeer: return "mug.fill"
        case .wine: return "wineglass.fill"
        case .smoothie: return "leaf.fill"
        case .juice: return "drop.triangle.fill"
        case .tea: return "leaf"
        case .soda: return "bubbles.and.sparkles"
        case .other: return "cup.and.saucer"
        }
    }
}

struct MapStatPill: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.siplyJade)
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(label)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
