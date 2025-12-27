//
//  AddDrinkView.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI
import CoreLocation

struct AddDrinkView: View {
    @EnvironmentObject var drinkManager: DrinkManager
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var achievementManager: AchievementManager
    @Environment(\.dismiss) var dismiss
    
    @State private var drinkName = ""
    @State private var selectedCategory: DrinkCategory = .cocktail
    @State private var rating: Double = 3.0
    @State private var notes = ""
    @State private var locationName = ""
    @State private var price = ""
    @State private var tags = ""
    @State private var isPublic = true
    @State private var useCurrentLocation = true
    @State private var showingSuccessAlert = false
    @State private var selectedImage: UIImage?
    @State private var showingCamera = false
    @State private var showingImageOptions = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.siplyBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with logo
                        VStack(spacing: 16) {
                            SiplyLogo(size: 60, animated: false)
                            
                            VStack(spacing: 8) {
                                Text("Log a Drink")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.siplyJade)
                                
                                Text("Share your experience")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.top)
                        
                        // Photo Section
                        photoSection
                        
                        // Category Selection
                        categorySection
                        
                        // Drink Details
                        drinkDetailsSection
                        
                        // Rating
                        ratingSection
                        
                        // Location
                        locationSection
                        
                        // Additional Info
                        additionalInfoSection
                        
                        // Privacy
                        privacySection
                        
                        // Submit Button
                        Button(action: saveDrink) {
                            Text("Log Drink")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.siplyCharcoal)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.siplyJade)
                                .cornerRadius(12)
                        }
                        .disabled(drinkName.isEmpty)
                        .opacity(drinkName.isEmpty ? 0.5 : 1.0)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                locationManager.getCurrentLocation()
            }
            .alert("Drink Logged!", isPresented: $showingSuccessAlert) {
                Button("OK") {
                    clearForm()
                }
            } message: {
                Text("Your drink has been added to your journal!")
            }
            .sheet(isPresented: $showingCamera) {
                CameraImagePicker(selectedImage: $selectedImage)
            }
            .confirmationDialog("Add Photo", isPresented: $showingImageOptions) {
                Button("Take Photo") {
                    showingCamera = true
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
    
    private var photoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Photo")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("(Optional)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                if selectedImage != nil {
                    Button(action: {
                        showingImageOptions = true
                    }) {
                        Text("Change")
                            .font(.caption)
                            .foregroundColor(.siplyJade)
                    }
                }
            }
            
            ImagePicker(selectedImage: $selectedImage)
        }
    }
    
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Category")
                .font(.headline)
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(DrinkCategory.allCases, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                        }) {
                            VStack {
                                Text(category.icon)
                                    .font(.title2)
                                Text(category.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .frame(width: 100)
                            .background(selectedCategory == category ? Color.siplyMagenta : Color.siplyCardBackground)
                            .cornerRadius(12)
                        }
                    }
                }
            }
        }
    }
    
    private var drinkDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Drink Name *")
                    .font(.headline)
                    .foregroundColor(.white)
                
                TextField("e.g., Espresso Martini", text: $drinkName)
                    .padding()
                    .background(Color.siplyCardBackground)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Notes")
                    .font(.headline)
                    .foregroundColor(.white)
                
                TextEditor(text: $notes)
                    .frame(height: 100)
                    .padding(8)
                    .background(Color.siplyCardBackground)
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .overlay(
                        Group {
                            if notes.isEmpty {
                                Text("How was it? What did you think?")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 12)
                                    .padding(.top, 16)
                                    .allowsHitTesting(false)
                            }
                        },
                        alignment: .topLeading
                    )
            }
        }
    }
    
    private var ratingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Rating")
                .font(.headline)
                .foregroundColor(.white)
            
            VStack(spacing: 8) {
                HStack {
                    ForEach(1...5, id: \.self) { star in
                        Button(action: {
                            rating = Double(star)
                        }) {
                            Image(systemName: Double(star) <= rating ? "star.fill" : "star")
                                .foregroundColor(.siplyJade)
                                .font(.title)
                        }
                    }
                }
                
                Text(String(format: "%.1f / 5.0", rating))
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.siplyCardBackground)
            .cornerRadius(12)
        }
    }
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Location")
                .font(.headline)
                .foregroundColor(.white)
            
            Toggle(isOn: $useCurrentLocation) {
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.siplyLightBrown)
                    Text("Use Current Location")
                        .foregroundColor(.white)
                }
            }
            .tint(.siplyJade)
            .padding()
            .background(Color.siplyCardBackground)
            .cornerRadius(8)
            
            if useCurrentLocation {
                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.siplyLightBrown)
                    Text(locationManager.currentLocationName.isEmpty ? "Getting location..." : locationManager.currentLocationName)
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.siplyCharcoal)
                .cornerRadius(8)
            } else {
                TextField("Enter location manually", text: $locationName)
                    .padding()
                    .background(Color.siplyCardBackground)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
        }
    }
    
    private var additionalInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Price (Optional)")
                    .font(.headline)
                    .foregroundColor(.white)
                
                TextField("e.g., 12.50", text: $price)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.siplyCardBackground)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Tags (Optional)")
                    .font(.headline)
                    .foregroundColor(.white)
                
                TextField("e.g., sweet, creamy, strong", text: $tags)
                    .padding()
                    .background(Color.siplyCardBackground)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
        }
    }
    
    private var privacySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Privacy")
                .font(.headline)
                .foregroundColor(.white)
            
            Toggle(isOn: $isPublic) {
                HStack {
                    Image(systemName: isPublic ? "globe" : "lock.fill")
                        .foregroundColor(isPublic ? .siplyJade : .gray)
                    Text(isPublic ? "Public - Share with community" : "Private - Only you can see")
                        .foregroundColor(.white)
                        .font(.subheadline)
                }
            }
            .tint(.siplyJade)
            .padding()
            .background(Color.siplyCardBackground)
            .cornerRadius(8)
        }
    }
    
    private func saveDrink() {
        let finalLocationName: String
        var latitude: Double?
        var longitude: Double?
        
        if useCurrentLocation {
            finalLocationName = locationManager.currentLocationName
            latitude = locationManager.location?.coordinate.latitude
            longitude = locationManager.location?.coordinate.longitude
        } else {
            finalLocationName = locationName
        }
        
        let priceValue = Double(price)
        let tagArray = tags.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
        
        // Convert image to data
        let imageData = selectedImage?.jpegData(compressionQuality: 0.7)
        
        let newDrink = Drink(
            name: drinkName,
            category: selectedCategory,
            rating: rating,
            notes: notes,
            imageData: imageData,
            locationName: finalLocationName,
            latitude: latitude,
            longitude: longitude,
            tags: tagArray,
            price: priceValue,
            isPublic: isPublic
        )
        
        drinkManager.addDrink(newDrink)
        
        // Check for achievements
        achievementManager.checkAchievements(
            drinkCount: drinkManager.getTotalDrinks(),
            locationCount: drinkManager.getTotalLocations(),
            hasAllCategories: drinkManager.hasAllCategories(),
            hasFiveStarRating: drinkManager.hasFiveStarRating()
        )
        
        HapticManager.shared.notification(type: .success)
        showingSuccessAlert = true
    }
    
    private func clearForm() {
        drinkName = ""
        selectedCategory = .cocktail
        rating = 3.0
        notes = ""
        locationName = ""
        price = ""
        tags = ""
        isPublic = true
        useCurrentLocation = true
        selectedImage = nil
    }
}

#Preview {
    AddDrinkView()
        .environmentObject(DrinkManager())
        .environmentObject(LocationManager())
}
