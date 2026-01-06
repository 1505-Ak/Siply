//
//  SimpleMapMarker.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI

struct DrinkIconMarker: View {
    let drink: Drink
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.siplyJade.opacity(0.22))
                .frame(width: 34, height: 34)
                .blur(radius: 3)
            
            Circle()
                .fill(Color.siplyCardBackground)
                .frame(width: 30, height: 30)
                .overlay(
                    Circle()
                        .stroke(Color.siplyJade, lineWidth: 2)
                )
                .overlay(
                    Text(drink.category.icon)
                        .font(.system(size: 16))
                )
                .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 2)
        }
    }
}

struct MinimalistDrinkCard: View {
    let drink: Drink
    let onClose: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            // Small preview
            Group {
                if let imageData = drink.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 46, height: 46)
                        .clipped()
                        .cornerRadius(8)
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.siplyJade.opacity(0.2))
                        .frame(width: 46, height: 46)
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
        .padding(9)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.siplyCardBackground)
                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 2)
        )
    }
}
