//
//  SimpleMapMarker.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI

struct SimpleMapMarker: View {
    var body: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(Color.siplyJade.opacity(0.3))
                .frame(width: 28, height: 28)
                .blur(radius: 3)
            
            // Main circle
            Circle()
                .fill(Color.siplyJade)
                .frame(width: 14, height: 14)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
        }
    }
}

struct MinimalistDrinkCard: View {
    let drink: Drink
    let onClose: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Small preview
            Group {
                if let imageData = drink.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipped()
                        .cornerRadius(8)
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.siplyJade.opacity(0.2))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: "wineglass.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.siplyJade)
                        )
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(drink.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                HStack(spacing: 2) {
                    ForEach(0..<Int(drink.rating)) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.siplyJade)
                            .font(.system(size: 8))
                    }
                }
                
                Text(drink.locationName)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .foregroundColor(.gray)
                    .font(.system(size: 14, weight: .medium))
                    .padding(8)
                    .background(Color.siplyCharcoal)
                    .clipShape(Circle())
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.siplyCardBackground)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        )
    }
}
