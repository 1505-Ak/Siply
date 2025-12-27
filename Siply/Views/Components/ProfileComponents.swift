//
//  ProfileComponents.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI

struct FavoriteDrinkCard: View {
    let drink: Drink
    
    var body: some View {
        HStack(spacing: 12) {
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
                            Image(systemName: "wineglass.fill")
                                .foregroundColor(.white)
                        )
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(drink.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(drink.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.siplyJade)
                
                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        Image(systemName: Double(index) < drink.rating ? "star.fill" : "star")
                            .foregroundColor(.siplyJade)
                            .font(.system(size: 10))
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "heart.fill")
                .foregroundColor(.siplyMagenta)
        }
        .padding()
        .background(Color.siplyCardBackground)
        .cornerRadius(12)
    }
}

struct EmptyFavoriteCard: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.slash")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            VStack(spacing: 4) {
                Text("No Signature Drink")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("Mark a drink as favorite to showcase it here")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color.siplyCardBackground)
        .cornerRadius(16)
    }
}

struct SocialStatCard: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.siplyCardBackground)
        .cornerRadius(12)
    }
}

// Enhanced Social Stat Card with better design
struct EnhancedSocialStatCard: View {
    let value: String
    let label: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.siplyJade)
            
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.siplyCardBackground)
        .cornerRadius(12)
    }
}

// Competitive Stat Card - Makes cities/countries stand out!
struct CompetitiveStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let detail: String
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon with pulsing background
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: isAnimating ? 60 : 55, height: isAnimating ? 60 : 55)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
                
                Image(systemName: icon)
                    .font(.system(size: 26))
                    .foregroundColor(color)
            }
            
            // Big number
            Text(value)
                .font(.system(size: 42, weight: .bold))
                .foregroundColor(.white)
            
            // Title and detail
            VStack(spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(detail)
                    .font(.caption)
                    .foregroundColor(color)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.siplyCardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
        .onAppear {
            isAnimating = true
        }
    }
}

// Mini stat cards for additional info
struct MiniStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.siplyCardBackground)
        .cornerRadius(12)
    }
}

// Enhanced Favorite Drink Card - more prominent
struct EnhancedFavoriteDrinkCard: View {
    let drink: Drink
    
    var body: some View {
        NavigationLink(destination: DrinkDetailView(drink: drink)) {
            VStack(spacing: 0) {
                // Image at top
                Group {
                    if let imageData = drink.imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 160)
                            .clipped()
                    } else {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(
                                LinearGradient(
                                    colors: [Color.siplyMagenta, Color.siplyJade],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 160)
                            .overlay(
                                Image(systemName: "wineglass.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white.opacity(0.5))
                            )
                    }
                }
                
                // Info section
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(drink.name)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 4) {
                            ForEach(0..<Int(drink.rating)) { _ in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.siplyMagenta)
                                    .font(.system(size: 12))
                            }
                            Text(String(format: "%.1f", drink.rating))
                                .font(.subheadline)
                                .foregroundColor(.siplyMagenta)
                        }
                        
                        HStack(spacing: 6) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(drink.locationName)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.title2)
                        .foregroundColor(.siplyMagenta)
                }
                .padding()
            }
            .background(Color.siplyCardBackground)
            .cornerRadius(16)
            .shadow(color: .siplyMagenta.opacity(0.2), radius: 10, x: 0, y: 5)
        }
    }
}
