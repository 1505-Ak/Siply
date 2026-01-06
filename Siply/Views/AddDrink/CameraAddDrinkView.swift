//
//  CameraAddDrinkView.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI
import CoreLocation
import Combine

struct CameraAddDrinkView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showCamera = true
    @State private var selectedImage: UIImage?
    @State private var showReviewScreen = false
    
    var body: some View {
        ZStack {
            if showCamera && !showReviewScreen {
                CameraImagePicker(selectedImage: $selectedImage)
                    .onChange(of: selectedImage) { _, newValue in
                        if newValue != nil {
                            showReviewScreen = true
                        }
                    }
            } else if showReviewScreen {
                DrinkReviewView(image: $selectedImage) {
                    dismiss()
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct DrinkReviewView: View {
    @Binding var image: UIImage?
    let onComplete: () -> Void
    
    @EnvironmentObject var drinkManager: DrinkManager
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var achievementManager: AchievementManager
    
    @State private var drinkName = ""
    @State private var selectedCategory: DrinkCategory = .cocktail
    @State private var rating: Double = 2.5
    @State private var notes = ""
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    @State private var isUploading = false
    @State private var uploadError: String?
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        ZStack {
            Color.siplyBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { onComplete() }) {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                    Text("Rate & Name it!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    // Invisible spacer for balance
                    Color.clear
                        .frame(width: 44, height: 44)
                }
                .padding(.horizontal)
                .background(Color.siplyBackground)
                
                // Large drink image with swipe-to-rate overlay
                ZStack {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: UIScreen.main.bounds.height * 0.5)
                            .clipped()
                            .overlay(
                                // Dark overlay for better star visibility
                                LinearGradient(
                                    colors: [Color.black.opacity(0.3), Color.clear, Color.black.opacity(0.5)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    
                    // Star rating overlay on image
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 16) {
                            // Swipe instruction
                            if !isDragging && rating == 2.5 {
                                Text("← Swipe on image to rate →")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.black.opacity(0.6))
                                    .cornerRadius(20)
                                    .transition(.opacity)
                            }
                            
                            // Star display
                            HStack(spacing: 8) {
                                ForEach(0..<5) { index in
                                    Image(systemName: Double(index) < rating ? "star.fill" : "star")
                                        .font(.system(size: 36))
                                        .foregroundColor(Double(index) < rating ? .siplyJade : .white.opacity(0.3))
                                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                                }
                            }
                            .scaleEffect(isDragging ? 1.1 : 1.0)
                            .animation(.spring(response: 0.3), value: isDragging)
                            
                            // Rating text
                            Text(String(format: "%.1f ★", rating))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.siplyJade)
                                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                        }
                        .padding(.bottom, 40)
                    }
                }
                .frame(height: UIScreen.main.bounds.height * 0.5)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDragging = true
                            dragOffset = value.translation.width
                            // Map swipe to rating: swipe right = higher, swipe left = lower
                            let progress = value.translation.width / 150 // Sensitivity
                            let newRating = 2.5 + progress
                            rating = min(max(newRating, 0.5), 5.0)
                            
                            // Haptic feedback at each star
                            let roundedRating = round(rating * 2) / 2
                            if abs(roundedRating - rating) < 0.1 {
                                HapticManager.shared.selection()
                            }
                        }
                        .onEnded { _ in
                            isDragging = false
                            withAnimation(.spring(response: 0.3)) {
                                dragOffset = 0
                                // Snap to nearest 0.5
                                rating = round(rating * 2) / 2
                            }
                            HapticManager.shared.impact(style: .medium)
                        }
                )
                
                // Minimal form - only 3 fields
                ScrollView {
                    VStack(spacing: 16) {
                        // Field 1: Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                            TextField("What did you drink?", text: $drinkName)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.siplyCardBackground)
                                .cornerRadius(12)
                        }
                        
                        // Field 2: Category (quick select)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(DrinkCategory.allCases, id: \.self) { category in
                                        Button(action: {
                                            selectedCategory = category
                                            HapticManager.shared.selection()
                                        }) {
                                            HStack(spacing: 6) {
                                                Image(systemName: categoryIcon(category))
                                                    .font(.caption)
                                                Text(category.rawValue)
                                                    .font(.caption)
                                                    .fontWeight(.semibold)
                                            }
                                            .foregroundColor(selectedCategory == category ? .siplyCharcoal : .white)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 10)
                                            .background(selectedCategory == category ? Color.siplyJade : Color.siplyCardBackground)
                                            .cornerRadius(20)
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Field 3: Notes (optional)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes (optional)")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                            TextField("Any thoughts?", text: $notes, axis: .vertical)
                                .foregroundColor(.white)
                                .lineLimit(2...4)
                                .padding()
                                .background(Color.siplyCardBackground)
                                .cornerRadius(12)
                        }
                        
                        // Error message
                        if let error = uploadError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                        
                        // Post button
                        Button(action: saveDrink) {
                            HStack {
                                if isUploading {
                                    ProgressView()
                                        .tint(.siplyCharcoal)
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title3)
                                    Text("Post to Journal")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                }
                            }
                            .foregroundColor(.siplyCharcoal)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [Color.siplyJade, Color.siplyJade.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: Color.siplyJade.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .disabled(drinkName.isEmpty || isUploading)
                        .opacity(drinkName.isEmpty || isUploading ? 0.5 : 1.0)
                        .padding(.top, 8)
                    }
                    .padding()
                }
                .background(Color.siplyBackground)
            }
        }
    }
    
    
    private func categoryIcon(_ category: DrinkCategory) -> String {
        switch category {
        case .cocktail: return "wineglass"
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
    
    private func saveDrink() {
        guard let imageData = image?.jpegData(compressionQuality: 0.7) else {
            uploadError = "Failed to process image"
            return
        }
        
        isUploading = true
        uploadError = nil
        
        // First upload the image
        APIClient.shared.uploadImage(imageData)
            .flatMap { uploadResponse -> AnyPublisher<DrinkResponse, Error> in
                // Then create the drink with the image URL
                let drinkCreate = DrinkCreate(
                    name: self.drinkName,
                    category: self.selectedCategory.rawValue,
                    rating: self.rating,
                    price: nil,
                    notes: self.notes.isEmpty ? nil : self.notes,
                    locationName: self.locationManager.currentLocationName.isEmpty ? nil : self.locationManager.currentLocationName,
                    locationCity: nil,
                    locationCountry: nil,
                    latitude: self.locationManager.location?.coordinate.latitude,
                    longitude: self.locationManager.location?.coordinate.longitude,
                    imageUrl: uploadResponse.url
                )
                
                return APIClient.shared.createDrink(drink: drinkCreate)
            }
            .sink { [self] completion in
                isUploading = false
                if case .failure(let error) = completion {
                    uploadError = error.localizedDescription
                }
            } receiveValue: { [self] response in
                // Save locally as well for immediate UI update
                let newDrink = Drink(
                    name: drinkName,
                    category: selectedCategory,
                    rating: rating,
                    notes: notes,
                    imageData: imageData,
                    locationName: locationManager.currentLocationName.isEmpty ? "Unknown Location" : locationManager.currentLocationName,
                    latitude: locationManager.location?.coordinate.latitude,
                    longitude: locationManager.location?.coordinate.longitude,
                    tags: [],
                    price: nil
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
                onComplete()
            }
            .store(in: &cancellables)
    }
}
