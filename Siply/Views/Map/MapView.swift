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
    @State private var selectedCity = "London, UK"
    @State private var showCityPicker = false
    
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
                Map(coordinateRegion: $region, annotationItems: drinksWithLocations) { drink in
                    MapAnnotation(coordinate: drink.coordinate!) {
                        SimpleMapMarker()
                            .onTapGesture {
                                withAnimation {
                                    selectedDrink = drink
                                }
                            }
                    }
                }
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom header
                    customMapHeader
                    
                    Spacer()
                    
                    // Selected drink card
                    if let drink = selectedDrink {
                        MinimalistDrinkCard(drink: drink, onClose: {
                            withAnimation {
                                selectedDrink = nil
                            }
                        })
                        .padding()
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showCityPicker) {
                CityPickerView(selectedCity: $selectedCity, cities: cities, onCitySelected: { city in
                    updateRegionForCity(city)
                })
            }
            .onAppear {
                if let location = locationManager.location {
                    region.center = location.coordinate
                }
            }
        }
    }
    
    private func updateRegionForCity(_ city: String) {
        if let coordinate = cityCoordinates[city] {
            withAnimation {
                region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            }
        }
    }
    
    private var customMapHeader: some View {
        VStack(spacing: 0) {
            // Black top border
            Rectangle()
                .fill(Color.black)
                .frame(height: 1)
            
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

struct DrinkMapMarker: View {
    let drink: Drink
    
    var body: some View {
        VStack(spacing: 0) {
            Text(drink.category.icon)
                .font(.title2)
                .padding(8)
                .background(Color.siplyMagenta)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
            
            // Pin tail
            Path { path in
                path.move(to: CGPoint(x: 20, y: 0))
                path.addLine(to: CGPoint(x: 15, y: 10))
                path.addLine(to: CGPoint(x: 25, y: 10))
                path.closeSubpath()
            }
            .fill(Color.siplyMagenta)
            .frame(width: 40, height: 10)
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
