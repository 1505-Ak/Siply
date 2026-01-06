//
//  MapView.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @EnvironmentObject var drinkManager: DrinkManager
    @EnvironmentObject var locationManager: LocationManager
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var selectedDrink: Drink?
    @State private var showStats = false
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    ))
    @State private var selectedCity = "London, UK"
    @State private var showCityPicker = false
    @State private var showDrinkPicker = false
    @State private var searchText: String = ""
    
    let cities = [
        "London, UK", 
        "New York, USA", 
        "Tokyo, Japan", 
        "Paris, France", 
        "San Francisco, USA", 
        "Sydney, Australia",
        "Berlin, Germany",
        "Barcelona, Spain",
        "Dubai, UAE"
    ]
    
    let cityCoordinates: [String: CLLocationCoordinate2D] = [
        "London, UK": CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278),
        "New York, USA": CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
        "Tokyo, Japan": CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503),
        "Paris, France": CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
        "San Francisco, USA": CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        "Sydney, Australia": CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093),
        "Berlin, Germany": CLLocationCoordinate2D(latitude: 52.5200, longitude: 13.4050),
        "Barcelona, Spain": CLLocationCoordinate2D(latitude: 41.3851, longitude: 2.1734),
        "Dubai, UAE": CLLocationCoordinate2D(latitude: 25.2048, longitude: 55.2708)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(position: $cameraPosition) {
                    if let userLocation = locationManager.location {
                        UserAnnotation()
                            .foregroundStyle(Color.siplyJade)
                        Annotation("You", coordinate: userLocation.coordinate) {
                            Circle()
                                .fill(Color.siplyJade)
                                .frame(width: 10, height: 10)
                        }
                    }
                    
                    ForEach(drinksWithLocations) { drink in
                        if let coordinate = drink.coordinate {
                                Annotation(drink.name, coordinate: coordinate) {
                                    DrinkIconMarker(drink: drink)
                                        .onTapGesture {
                                            withAnimation {
                                                selectedDrink = drink
                                                // Zoom in on the tapped drink
                                                let zoomRegion = MKCoordinateRegion(
                                                    center: coordinate,
                                                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                                                )
                                                region = zoomRegion
                                                cameraPosition = .region(zoomRegion)
                                            }
                                        }
                                }
                        }
                    }
                }
                .mapStyle(.standard)
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom header
                    customMapHeader
                    
                    Spacer()
                    
                    // Selected drink card (lighter)
                    if let drink = selectedDrink {
                        MinimalistDrinkCard(drink: drink, onClose: {
                            withAnimation {
                                selectedDrink = nil
                            }
                        })
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }

                // Floating controls
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            FloatingCircleButton(icon: "scope") {
                                withAnimation { centerMapOnDrinks() }
                            }
                            FloatingCircleButton(icon: "list.bullet") {
                                showDrinkPicker = true
                            }
                            FloatingCircleButton(icon: showStats ? "info.circle.fill" : "info.circle") {
                                withAnimation { showStats.toggle() }
                            }
                        }
                        .padding(.trailing, 12)
                        .padding(.bottom, 12)
                    }
                }
                
                // Compact stats toggle overlay
                if showStats {
                    VStack {
                        HStack {
                            StatChip(title: "Drinks", value: "\(drinksWithLocations.count)")
                            StatChip(title: "Places", value: "\(drinkManager.getTotalLocations())")
                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.siplyCardBackground.opacity(0.9))
                        .cornerRadius(14)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 3)
                        
                        Spacer()
                    }
                    .padding(.top, 12)
                    .padding(.horizontal, 12)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showCityPicker) {
                CityPickerView(selectedCity: $selectedCity, cities: cities, onCitySelected: { city in
                    updateRegionForCity(city)
                })
            }
            .sheet(isPresented: $showDrinkPicker) {
                DrinkListSheet(drinks: filteredDrinks, searchText: $searchText) { drink in
                    if let coordinate = drink.coordinate {
                        withAnimation {
                            selectedDrink = drink
                            let zoomRegion = MKCoordinateRegion(
                                center: coordinate,
                                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                            )
                            region = zoomRegion
                            cameraPosition = .region(zoomRegion)
                        }
                    }
                }
            }
            .onAppear {
                if let location = locationManager.location {
                    region.center = location.coordinate
                    cameraPosition = .region(region)
                } else if let first = drinksWithLocations.first?.coordinate {
                    let newRegion = MKCoordinateRegion(center: first, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                    region = newRegion
                    cameraPosition = .region(newRegion)
                } else {
                    cameraPosition = .region(region)
                }
            }
        }
    }

    private var filteredDrinks: [Drink] {
        let base = drinksWithLocations
        guard !searchText.isEmpty else { return base }
        return base.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.locationName.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private func updateRegionForCity(_ city: String) {
        if let coordinate = cityCoordinates[city] {
            withAnimation {
                let newRegion = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
                region = newRegion
                cameraPosition = .region(newRegion)
            }
        }
    }

    private func centerMapOnDrinks() {
        guard !drinksWithLocations.isEmpty else { return }
        let coords = drinksWithLocations.compactMap { $0.coordinate }
        guard !coords.isEmpty else { return }
        
        let lats = coords.map { $0.latitude }
        let lons = coords.map { $0.longitude }
        guard let maxLat = lats.max(),
              let minLat = lats.min(),
              let maxLon = lons.max(),
              let minLon = lons.min() else { return }
        
        let center = CLLocationCoordinate2D(
            latitude: (maxLat + minLat) / 2,
            longitude: (maxLon + minLon) / 2
        )
        
        var latDelta = max((maxLat - minLat) * 1.5, 0.03)
        var lonDelta = max((maxLon - minLon) * 1.5, 0.03)
        let maxSpan: CLLocationDegrees = 0.5
        latDelta = min(latDelta, maxSpan)
        lonDelta = min(lonDelta, maxSpan)
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let newRegion = MKCoordinateRegion(center: center, span: span)
        withAnimation {
            region = newRegion
            cameraPosition = .region(newRegion)
        }
    }
    
    private var customMapHeader: some View {
        VStack(spacing: 0) {
            HStack {
                // City/Country selector on the left
                Button(action: { showCityPicker = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.siplyJade)
                            .font(.system(size: 16))
                        
                        Text(selectedCity)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(.siplyJade)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.siplyCardBackground)
                    .cornerRadius(25)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color.siplyBackground)
        }
    }
    
    private var drinksWithLocations: [Drink] {
        drinkManager.drinks.filter { $0.coordinate != nil }
    }
}

// Compact stat chip
private struct StatChip: View {
    let title: String
    let value: String
    var body: some View {
        HStack(spacing: 6) {
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.siplyCharcoal.opacity(0.9))
        .cornerRadius(12)
    }
}

// Reusable floating circular button
private struct FloatingCircleButton: View {
    let icon: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.siplyCharcoal)
                .padding(12)
                .background(Color.siplyJade)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
        }
    }
}

// Shared drink picker sheet for both main map and journal map
struct DrinkListSheet: View {
    let drinks: [Drink]
    @Binding var searchText: String
    let onSelect: (Drink) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search drinks or location", text: $searchText)
                            .autocapitalization(.none)
                    }
                    .padding(8)
                }
                
                Section {
                    if drinks.isEmpty {
                        Text("No drinks found")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(drinks) { drink in
                            Button {
                                onSelect(drink)
                                dismiss()
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(drink.name)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text(drink.locationName)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.siplyCardBackground)
                                .cornerRadius(12)
                            }
                            .buttonStyle(.plain)
                            .listRowBackground(Color.clear)
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.siplyBackground)
            .navigationTitle("Find a Drink")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .foregroundColor(.siplyJade)
                }
            }
        }
    }
}

struct DrinkMapCard: View {
    let drink: Drink
    let onClose: () -> Void
    @EnvironmentObject var drinkManager: DrinkManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(drink.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(drink.category.rawValue)
                        .font(.caption)
                        .foregroundColor(.siplyJade)
                }
                
                Spacer()
                
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
            }
            
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.siplyJade)
                Text(String(format: "%.1f", drink.rating))
                    .foregroundColor(.white)
                
                Text("•")
                    .foregroundColor(.gray)
                
                if let price = drink.price {
                    Text("$\(String(format: "%.2f", price))")
                        .foregroundColor(.white)
                }
            }
            .font(.caption)
            
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.siplyLightBrown)
                Text(drink.locationName)
                    .foregroundColor(.white)
                    .font(.caption)
            }
            
            if !drink.notes.isEmpty {
                Text(drink.notes)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            HStack {
                Button(action: {
                    drinkManager.toggleFavorite(drink)
                }) {
                    HStack {
                        Image(systemName: drink.isFavorite ? "heart.fill" : "heart")
                        Text(drink.isFavorite ? "Favorited" : "Favorite")
                    }
                    .font(.caption)
                    .foregroundColor(drink.isFavorite ? .siplyMagenta : .white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.siplyCharcoal)
                    .cornerRadius(20)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.siplyMagenta)
                    Text("\(drink.likes)")
                        .foregroundColor(.white)
                }
                .font(.caption)
            }
        }
        .padding()
        .background(Color.siplyCardBackground)
        .cornerRadius(16)
        .shadow(radius: 10)
    }
}

#Preview {
    MapView()
        .environmentObject(DrinkManager())
        .environmentObject(LocationManager())
}
