//
//  AchievementBadge.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI
import Combine

struct AchievementBadge: View {
    let achievement: Achievement
    let isUnlocked: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? Color.siplyJade.opacity(0.2) : Color.siplyCharcoal)
                    .frame(width: 60, height: 60)
                
                Text(achievement.icon)
                    .font(.system(size: 30))
                    .grayscale(isUnlocked ? 0 : 1)
                    .opacity(isUnlocked ? 1 : 0.3)
            }
            
            Text(achievement.rawValue)
                .font(.caption2)
                .foregroundColor(isUnlocked ? .white : .gray)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 70)
        }
        .padding(8)
        .background(Color.siplyCardBackground)
        .cornerRadius(12)
    }
}
