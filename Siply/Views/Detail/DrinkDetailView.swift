//
//  DrinkDetailView.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI
import MapKit
import CoreLocation

struct DrinkDetailView: View {
    let drink: Drink
    @EnvironmentObject var drinkManager: DrinkManager
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    @State private var showingShareSheet = false
    
    var body: some View {
        ZStack {
            Color.siplyBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header Image
                    headerSection
                    
                    // Drink Info
                    VStack(alignment: .leading, spacing: 16) {
                        // Title and Category
                        titleSection
                        
                        // Rating
                        ratingSection
                        
                        // Location
                        locationSection
                        
                        // Price & Tags
                        if drink.price != nil || !drink.tags.isEmpty {
                            additionalInfoSection
                        }
                        
                        // Notes
                        if !drink.notes.isEmpty {
                            notesSection
                        }
                        
                        // Social Stats
                        socialSection
                        
                        // Map Preview
                        if drink.coordinate != nil {
                            mapSection
                        }
                        
                        // Action Buttons
                        actionButtons
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { showingShareSheet = true }) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    
                    Button(role: .destructive, action: { showingDeleteAlert = true }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.siplyJade)
                }
            }
        }
        .alert("Delete Drink?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                drinkManager.deleteDrink(drink)
                dismiss()
            }
        } message: {
            Text("This action cannot be undone.")
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(drink: drink)
        }
    }
    
    private var headerSection: some View {
        Group {
            if let imageData = drink.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300)
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: 0)
                    .fill(
                        LinearGradient(
                            colors: [Color.siplyMagenta, Color.siplyLightBrown],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 250)
                    .overlay(
                        VStack {
                            Spacer()
                            Text(drink.category.icon)
                                .font(.system(size: 100))
                            Spacer()
                        }
                    )
            }
        }
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(drink.name)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Text(drink.category.rawValue)
                .font(.subheadline)
                .foregroundColor(.siplyJade)
            
            Text(drink.date, style: .date)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
    
    private var ratingSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Rating")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack {
                ForEach(0..<5) { index in
                    Image(systemName: Double(index) < drink.rating ? "star.fill" : "star")
                        .foregroundColor(.siplyJade)
                        .font(.title2)
                }
                Text(String(format: "%.1f / 5.0", drink.rating))
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.siplyCardBackground)
        .cornerRadius(12)
    }
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Location")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.siplyLightBrown)
                    .font(.title2)
                Text(drink.locationName)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.siplyCardBackground)
        .cornerRadius(12)
    }
    
    private var additionalInfoSection: some View {
        HStack(spacing: 12) {
            if let price = drink.price {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Price")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("$\(String(format: "%.2f", price))")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.siplyCardBackground)
                .cornerRadius(12)
            }
            
            if !drink.tags.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Tags")
                        .font(.caption)
                        .foregroundColor(.gray)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(drink.tags, id: \.self) { tag in
                                Text("#\(tag)")
                                    .font(.caption)
                                    .foregroundColor(.siplyJade)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.siplyCharcoal)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.siplyCardBackground)
                .cornerRadius(12)
            }
        }
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notes")
                .font(.headline)
                .foregroundColor(.white)
            
            Text(drink.notes)
                .foregroundColor(.gray)
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.siplyCardBackground)
        .cornerRadius(12)
    }
    
    private var socialSection: some View {
        HStack(spacing: 20) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.siplyMagenta)
                Text("\(drink.likes)")
                    .foregroundColor(.white)
                Text("Likes")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            
            HStack {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.siplyJade)
                Text("\(drink.shares)")
                    .foregroundColor(.white)
                Text("Shares")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            
            Spacer()
            
            Image(systemName: drink.isPublic ? "globe" : "lock.fill")
                .foregroundColor(drink.isPublic ? .siplyJade : .gray)
        }
        .padding()
        .background(Color.siplyCardBackground)
        .cornerRadius(12)
    }
    
    private var mapSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Location on Map")
                .font(.headline)
                .foregroundColor(.white)
            
            if let coordinate = drink.coordinate {
                Map(coordinateRegion: .constant(MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )), annotationItems: [drink]) { drink in
                    MapMarker(coordinate: coordinate, tint: .siplyMagenta)
                }
                .frame(height: 200)
                .cornerRadius(12)
                .allowsHitTesting(false)
            }
        }
    }
    
    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button(action: {
                drinkManager.toggleFavorite(drink)
            }) {
                HStack {
                    Image(systemName: drink.isFavorite ? "heart.fill" : "heart")
                    Text(drink.isFavorite ? "Favorited" : "Favorite")
                }
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(drink.isFavorite ? .white : .siplyCharcoal)
                .frame(maxWidth: .infinity)
                .padding()
                .background(drink.isFavorite ? Color.siplyMagenta : Color.siplyJade)
                .cornerRadius(12)
            }
            
            Button(action: { showingShareSheet = true }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share")
                }
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.siplyLightBrown)
                .cornerRadius(12)
            }
        }
    }
}

struct ShareSheet: View {
    let drink: Drink
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.siplyBackground.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Share to Social Media")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    // Preview Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text(drink.name)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack {
                            Text(drink.category.icon)
                            Text(drink.category.rawValue)
                                .foregroundColor(.siplyJade)
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.siplyJade)
                                Text(String(format: "%.1f", drink.rating))
                                    .foregroundColor(.white)
                            }
                        }
                        .font(.caption)
                        
                        Text(drink.locationName)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.siplyCardBackground)
                    .cornerRadius(12)
                    .padding()
                    
                    // Social Media Buttons
                    VStack(spacing: 12) {
                        shareButton(title: "Share to Instagram", icon: "camera.fill", color: Color.purple)
                        shareButton(title: "Share to Twitter", icon: "bird.fill", color: Color.blue)
                        shareButton(title: "Copy Link", icon: "link", color: Color.siplyJade)
                    }
                    .padding()
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.siplyJade)
                }
            }
        }
    }
    
    private func shareButton(title: String, icon: String, color: Color) -> some View {
        Button(action: {
            // Share functionality would go here
        }) {
            HStack {
                Image(systemName: icon)
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .foregroundColor(.white)
            .padding()
            .background(color.opacity(0.2))
            .cornerRadius(12)
        }
    }
}

#Preview {
    NavigationView {
        DrinkDetailView(drink: Drink.sample)
            .environmentObject(DrinkManager())
    }
}
