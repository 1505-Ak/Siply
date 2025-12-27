//
//  PersonalMapComponents.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI

struct PersonalMapMarker: View {
    let drink: Drink
    @State private var pulse = false
    
    var body: some View {
        ZStack {
            // Pulsing outer ring
            Circle()
                .fill(categoryColor(drink.category).opacity(0.3))
                .frame(width: pulse ? 32 : 24, height: pulse ? 32 : 24)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulse)
            
            // Main marker
            Circle()
                .fill(categoryColor(drink.category))
                .frame(width: 16, height: 16)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
        }
        .onAppear {
            pulse = true
        }
    }
    
    private func categoryColor(_ category: DrinkCategory) -> Color {
        switch category {
        case .cocktail, .wine: return .siplyMagenta
        case .coffee, .tea: return .siplyLightBrown
        case .craftBeer, .bubbleTea: return .siplyJade
        default: return .siplyJade
        }
    }
}

struct PersonalDrinkCard: View {
    let drink: Drink
    let onClose: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Image
            Group {
                if let imageData = drink.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipped()
                        .cornerRadius(10)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.siplyJade.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "wineglass.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.siplyJade)
                        )
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(drink.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    ForEach(0..<Int(drink.rating)) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.siplyJade)
                            .font(.system(size: 10))
                    }
                    Text(String(format: "%.1f", drink.rating))
                        .font(.caption)
                        .foregroundColor(.siplyJade)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    Text(drink.locationName)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(8)
                        .background(Color.siplyCharcoal)
                        .clipShape(Circle())
                }
                
                NavigationLink(destination: DrinkDetailView(drink: drink)) {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.siplyCharcoal)
                        .padding(8)
                        .background(Color.siplyJade)
                        .clipShape(Circle())
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.siplyCardBackground)
                .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 5)
        )
    }
}

