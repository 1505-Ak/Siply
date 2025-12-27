//
//  AchievementPopup.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI

struct AchievementPopup: View {
    let achievement: Achievement
    @Binding var isShowing: Bool
    @State private var scale: CGFloat = 0.5
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Text(achievement.icon)
                    .font(.system(size: 40))
                    .scaleEffect(scale)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Achievement Unlocked!")
                        .font(.caption)
                        .foregroundColor(.siplyJade)
                        .fontWeight(.semibold)
                    
                    Text(achievement.rawValue)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(achievement.description)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: { isShowing = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.siplyCardBackground)
            .cornerRadius(16)
            .shadow(color: Color.siplyJade.opacity(0.3), radius: 20, x: 0, y: 10)
            .padding(.horizontal)
            .padding(.top, 50)
            
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                scale = 1.2
            }
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5).delay(0.2)) {
                scale = 1.0
            }
            
            // Auto dismiss after 4 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation {
                    isShowing = false
                }
            }
        }
    }
}

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}


