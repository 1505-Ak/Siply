//
//  AchievementsView.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var achievementManager: AchievementManager
    @EnvironmentObject var drinkManager: DrinkManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.siplyBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 12) {
                            Image(systemName: "trophy.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.siplyJade)
                            
                            Text("Achievements")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            HStack(spacing: 20) {
                                StatBubble(
                                    value: "\(achievementManager.unlockedAchievements.count)",
                                    label: "Unlocked",
                                    color: .siplyJade
                                )
                                
                                StatBubble(
                                    value: "\(Achievement.allCases.count - achievementManager.unlockedAchievements.count)",
                                    label: "Locked",
                                    color: .gray
                                )
                                
                                StatBubble(
                                    value: "\(Int((Double(achievementManager.unlockedAchievements.count) / Double(Achievement.allCases.count)) * 100))%",
                                    label: "Progress",
                                    color: .siplyMagenta
                                )
                            }
                        }
                        .padding()
                        
                        // Progress Bar
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Overall Progress")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(achievementManager.unlockedAchievements.count)/\(Achievement.allCases.count)")
                                    .font(.subheadline)
                                    .foregroundColor(.siplyJade)
                            }
                            
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.siplyCardBackground)
                                        .frame(height: 12)
                                    
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.siplyJade, Color.siplyMagenta],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(
                                            width: geometry.size.width * (Double(achievementManager.unlockedAchievements.count) / Double(Achievement.allCases.count)),
                                            height: 12
                                        )
                                }
                            }
                            .frame(height: 12)
                        }
                        .padding()
                        .background(Color.siplyCardBackground)
                        .cornerRadius(16)
                        .padding(.horizontal)
                        
                        // Unlocked Achievements
                        if !achievementManager.unlockedAchievements.isEmpty {
                            achievementSection(
                                title: "Unlocked",
                                achievements: Achievement.allCases.filter { achievementManager.unlockedAchievements.contains($0) },
                                isUnlocked: true
                            )
                        }
                        
                        // Locked Achievements
                        let lockedAchievements = Achievement.allCases.filter { !achievementManager.unlockedAchievements.contains($0) }
                        if !lockedAchievements.isEmpty {
                            achievementSection(
                                title: "Locked",
                                achievements: lockedAchievements,
                                isUnlocked: false
                            )
                        }
                    }
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.siplyJade)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func achievementSection(title: String, achievements: [Achievement], isUnlocked: Bool) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(achievements, id: \.self) { achievement in
                    AchievementCard(achievement: achievement, isUnlocked: isUnlocked)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    let isUnlocked: Bool
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(isUnlocked ? Color.siplyJade.opacity(0.2) : Color.gray.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Text(achievement.icon)
                    .font(.system(size: 40))
                    .opacity(isUnlocked ? 1.0 : 0.3)
                
                if isUnlocked {
                    Circle()
                        .stroke(Color.siplyJade, lineWidth: 2)
                        .frame(width: 80, height: 80)
                }
            }
            
            // Title
            Text(achievement.rawValue)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(isUnlocked ? .white : .gray)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            
            // Description
            Text(achievement.description)
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.siplyCardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isUnlocked ? Color.siplyJade.opacity(0.3) : Color.clear, lineWidth: 2)
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
                HapticManager.shared.selection()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    isPressed = false
                }
            }
        }
    }
}

struct StatBubble: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.siplyCardBackground)
        .cornerRadius(12)
    }
}

#Preview {
    AchievementsView()
        .environmentObject(AchievementManager())
        .environmentObject(DrinkManager())
}


