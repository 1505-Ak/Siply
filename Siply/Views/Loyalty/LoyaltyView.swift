//
//  LoyaltyView.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI

struct LoyaltyView: View {
    @EnvironmentObject var drinkManager: DrinkManager
    @State private var animateSips = false
    @State private var selectedReward: Reward?
    @State private var showSipsHistory = false
    
    var totalSips: Int {
        // 1 sip per drink logged, bonus sips for high ratings
        var sips = drinkManager.drinks.count
        let fiveStarDrinks = drinkManager.drinks.filter { $0.rating >= 5.0 }.count
        sips += fiveStarDrinks // Bonus sip for 5-star drinks
        return sips
    }
    
    var currentLevel: Int {
        // Level up every 10 sips
        return min(totalSips / 10, 10)
    }
    
    var sipsToNextLevel: Int {
        let nextLevelThreshold = (currentLevel + 1) * 10
        return max(0, nextLevelThreshold - totalSips)
    }
    
    var body: some View {
        ZStack {
            Color.siplyBackground.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Custom Header with coffee brown ribbon
                    customHeader
                    
                    VStack(spacing: 20) {
                        // Sips Card - Shows total and level
                        sipsCard
                        
                        // Quick Stats
                        quickStatsSection
                        
                        // Unlockable Rewards Progress
                        rewardsProgressSection
                        
                        // How to earn more sips
                        howToEarnSection
                        
                        // Achievements/Badges
                        achievementsSection
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(isPresented: $showSipsHistory) {
            SipsHistoryView(totalSips: totalSips, drinksCount: drinkManager.drinks.count)
        }
    }
    
    private var customHeader: some View {
        VStack(spacing: 0) {
            // Coffee brown ribbon on top
            Rectangle()
                .fill(Color.siplyLightBrown)
                .frame(height: 4)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Siply")
                        .font(.custom("TrebuchetMS-Bold", size: 28))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("Rewards")
                        .font(.custom("TrebuchetMS-Bold", size: 28))
                        .fontWeight(.bold)
                        .foregroundColor(.siplyJade)
                }
                
                Spacer()
                
                // Gift icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.siplyMagenta, .siplyJade],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 45, height: 45)
                    
                    Image(systemName: "gift.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
            }
            .padding()
            .background(Color.siplyBackground)
            
            // Subtle divider
            Rectangle()
                .fill(Color.siplyLightBrown.opacity(0.4))
                .frame(height: 1)
        }
    }
    
    private var sipsCard: some View {
        ZStack {
            // Animated gradient background
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.siplyMagenta.opacity(0.8),
                            Color.siplyJade.opacity(0.6),
                            Color.siplyLightBrown.opacity(0.5)
                        ],
                        startPoint: animateSips ? .topLeading : .bottomTrailing,
                        endPoint: animateSips ? .bottomTrailing : .topLeading
                    )
                )
                .shadow(color: Color.siplyMagenta.opacity(0.5), radius: 20, x: 0, y: 10)
            
            VStack(spacing: 15) {
                // Sips display
                VStack(spacing: 5) {
                    HStack(spacing: 8) {
                        Text("☕️")
                            .font(.system(size: 24))
                        Text("Total Sips")
                            .font(.custom("TrebuchetMS", size: 17))
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Text("\(totalSips)")
                        .font(.custom("TrebuchetMS-Bold", size: 65))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .scaleEffect(animateSips ? 1.05 : 1.0)
                    
                    // Level Badge
                    HStack(spacing: 6) {
                        Image(systemName: "star.circle.fill")
                            .foregroundColor(.yellow)
                        Text("Level \(currentLevel)")
                            .font(.custom("TrebuchetMS-Bold", size: 16))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(20)
                }
                
                // Progress to next level
                VStack(spacing: 8) {
                    HStack {
                        Text("Level \(currentLevel)")
                            .font(.custom("TrebuchetMS", size: 12))
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        Text("Level \(currentLevel + 1)")
                            .font(.custom("TrebuchetMS", size: 12))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.2))
                                .frame(height: 8)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.siplyJade)
                                .frame(width: geometry.size.width * levelProgress, height: 8)
                        }
                    }
                    .frame(height: 8)
                    
                    Text("\(sipsToNextLevel) sips to next level")
                        .font(.custom("TrebuchetMS", size: 13))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.horizontal, 20)
            }
            .padding(25)
        }
        .frame(height: 260)
        .padding(.horizontal)
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                animateSips = true
            }
        }
    }
    
    private var levelProgress: CGFloat {
        let currentLevelSips = currentLevel * 10
        let nextLevelSips = (currentLevel + 1) * 10
        let sipsInThisLevel = totalSips - currentLevelSips
        let sipsNeededForLevel = nextLevelSips - currentLevelSips
        return CGFloat(sipsInThisLevel) / CGFloat(sipsNeededForLevel)
    }
    
    private var quickStatsSection: some View {
        HStack(spacing: 12) {
            // Total drinks
            StatMiniCard(
                icon: "cup.and.saucer.fill",
                title: "Drinks",
                value: "\(drinkManager.drinks.count)",
                color: .siplyJade
            )
            
            // 5-Star drinks
            StatMiniCard(
                icon: "star.fill",
                title: "5-Star",
                value: "\(drinkManager.drinks.filter { $0.rating >= 5.0 }.count)",
                color: .yellow
            )
            
            // Current level
            StatMiniCard(
                icon: "trophy.fill",
                title: "Level",
                value: "\(currentLevel)",
                color: .siplyMagenta
            )
        }
        .padding(.horizontal)
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Achievements")
                .font(.custom("TrebuchetMS-Bold", size: 22))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    AchievementBadgeCard(
                        icon: "🏆",
                        title: "First Sip",
                        isUnlocked: totalSips >= 1,
                        requirement: "1 sip"
                    )
                    
                    AchievementBadgeCard(
                        icon: "🎯",
                        title: "Regular",
                        isUnlocked: totalSips >= 10,
                        requirement: "10 sips"
                    )
                    
                    AchievementBadgeCard(
                        icon: "⭐️",
                        title: "Enthusiast",
                        isUnlocked: totalSips >= 25,
                        requirement: "25 sips"
                    )
                    
                    AchievementBadgeCard(
                        icon: "👑",
                        title: "Connoisseur",
                        isUnlocked: totalSips >= 50,
                        requirement: "50 sips"
                    )
                    
                    AchievementBadgeCard(
                        icon: "💎",
                        title: "Legend",
                        isUnlocked: totalSips >= 100,
                        requirement: "100 sips"
                    )
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var howToEarnSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Earn More Sips")
                .font(.custom("TrebuchetMS-Bold", size: 22))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                EarnCard(icon: "camera.fill", title: "Log any drink", points: "+1 sip", color: .siplyJade)
                EarnCard(icon: "star.fill", title: "Give a 5-star rating", points: "+1 bonus sip", color: .yellow)
                EarnCard(icon: "person.2.fill", title: "Tag a friend", points: "+1 sip", color: .siplyMagenta)
                EarnCard(icon: "trophy.fill", title: "Complete daily challenge", points: "+3 sips", color: .siplyLightBrown)
            }
            .padding(.horizontal)
        }
    }
    
    private var rewardsProgressSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Rewards Progress")
                    .font(.custom("TrebuchetMS-Bold", size: 22))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: { showSipsHistory = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 12))
                        Text("History")
                            .font(.custom("TrebuchetMS", size: 13))
                    }
                    .foregroundColor(.siplyJade)
                }
            }
            .padding(.horizontal)
            
            VStack(spacing: 12) {
                // Level-based rewards
                RewardProgressCard(
                    title: "Profile Badge",
                    description: "Unlock custom profile badge",
                    icon: "⭐️",
                    requiredSips: 10,
                    currentSips: totalSips,
                    level: 1
                )
                
                RewardProgressCard(
                    title: "Early Access",
                    description: "Try new features first",
                    icon: "🚀",
                    requiredSips: 25,
                    currentSips: totalSips,
                    level: 3
                )
                
                RewardProgressCard(
                    title: "Custom Theme",
                    description: "Unlock exclusive app themes",
                    icon: "🎨",
                    requiredSips: 50,
                    currentSips: totalSips,
                    level: 5
                )
                
                RewardProgressCard(
                    title: "VIP Status",
                    description: "Priority support & features",
                    icon: "👑",
                    requiredSips: 100,
                    currentSips: totalSips,
                    level: 10
                )
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Earn Card
struct EarnCard: View {
    let icon: String
    let title: String
    let points: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 20))
            }
            
            Text(title)
                .font(.custom("TrebuchetMS", size: 17))
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Spacer()
            
            Text(points)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.siplyJade)
        }
        .padding()
        .background(Color.siplyCardBackground)
        .cornerRadius(15)
    }
}

// MARK: - Reward Card
struct RewardCard: View {
    let reward: Reward
    let userPoints: Int
    let onTap: () -> Void
    
    var canClaim: Bool {
        userPoints >= reward.pointsRequired
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Reward icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: canClaim ? [.siplyJade, .siplyMagenta] : [.gray.opacity(0.3), .gray.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Text(reward.emoji)
                    .font(.system(size: 40))
            }
            
            Text(reward.name)
                .font(.custom("TrebuchetMS-Bold", size: 16))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 40)
            
            Text("\(reward.pointsRequired) pts")
                .font(.custom("TrebuchetMS", size: 14))
                .foregroundColor(canClaim ? .siplyJade : .gray)
                .fontWeight(.bold)
            
            Button(action: onTap) {
                Text(canClaim ? "Claim" : "Locked")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(canClaim ? .siplyCharcoal : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(canClaim ? Color.siplyJade : Color.gray.opacity(0.3))
                    .cornerRadius(10)
            }
            .disabled(!canClaim)
        }
        .padding()
        .frame(width: 160)
        .background(Color.siplyCardBackground)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(canClaim ? Color.siplyJade.opacity(0.5) : Color.clear, lineWidth: 2)
        )
        .shadow(color: canClaim ? Color.siplyJade.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 5)
    }
}

// MARK: - Partner Bar Card
struct PartnerBarCard: View {
    let name: String
    let location: String
    let discount: String
    let logo: String
    
    var body: some View {
        HStack(spacing: 15) {
            Text(logo)
                .font(.system(size: 40))
                .frame(width: 60, height: 60)
                .background(Color.siplyLightBrown.opacity(0.2))
                .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.custom("TrebuchetMS-Bold", size: 17))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(location)
                    .font(.custom("TrebuchetMS", size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(discount)
                    .font(.custom("TrebuchetMS-Bold", size: 14))
                    .fontWeight(.bold)
                    .foregroundColor(.siplyJade)
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            }
        }
        .padding()
        .background(Color.siplyCardBackground)
        .cornerRadius(15)
    }
}

// MARK: - New Components

struct StatMiniCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(.custom("TrebuchetMS-Bold", size: 20))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.custom("TrebuchetMS", size: 12))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(Color.siplyCardBackground)
        .cornerRadius(15)
    }
}

struct RewardProgressCard: View {
    let title: String
    let description: String
    let icon: String
    let requiredSips: Int
    let currentSips: Int
    let level: Int
    
    var isUnlocked: Bool {
        currentSips >= requiredSips
    }
    
    var progress: CGFloat {
        min(CGFloat(currentSips) / CGFloat(requiredSips), 1.0)
    }
    
    var body: some View {
        HStack(spacing: 15) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(
                        isUnlocked ?
                        LinearGradient(
                            colors: [.siplyJade, .siplyMagenta],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [.gray.opacity(0.3), .gray.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                
                if isUnlocked {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .offset(x: 18, y: -18)
                }
                
                Text(icon)
                    .font(.system(size: 30))
                    .grayscale(isUnlocked ? 0 : 0.8)
                    .opacity(isUnlocked ? 1 : 0.5)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(title)
                        .font(.custom("TrebuchetMS-Bold", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(isUnlocked ? .white : .gray)
                    
                    Spacer()
                    
                    if isUnlocked {
                        Text("UNLOCKED")
                            .font(.custom("TrebuchetMS-Bold", size: 10))
                            .fontWeight(.bold)
                            .foregroundColor(.siplyJade)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.siplyJade.opacity(0.2))
                            .cornerRadius(8)
                    } else {
                        Text("Level \(level)")
                            .font(.custom("TrebuchetMS", size: 11))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                
                Text(description)
                    .font(.custom("TrebuchetMS", size: 13))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 6)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: isUnlocked ? [.siplyJade, .siplyMagenta] : [.siplyJade.opacity(0.7), .siplyJade.opacity(0.5)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * progress, height: 6)
                    }
                }
                .frame(height: 6)
                
                if !isUnlocked {
                    Text("\(currentSips)/\(requiredSips) sips")
                        .font(.custom("TrebuchetMS", size: 11))
                        .foregroundColor(.siplyJade)
                }
            }
        }
        .padding()
        .background(Color.siplyCardBackground)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isUnlocked ? Color.siplyJade.opacity(0.5) : Color.clear, lineWidth: 2)
        )
    }
}

struct AchievementBadgeCard: View {
    let icon: String
    let title: String
    let isUnlocked: Bool
    let requirement: String
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(
                        isUnlocked ?
                        LinearGradient(
                            colors: [.siplyMagenta, .siplyJade],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [.gray.opacity(0.3), .gray.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 70, height: 70)
                
                Text(icon)
                    .font(.system(size: 35))
                    .grayscale(isUnlocked ? 0 : 1)
                    .opacity(isUnlocked ? 1 : 0.4)
            }
            
            Text(title)
                .font(.custom("TrebuchetMS-Bold", size: 14))
                .fontWeight(.bold)
                .foregroundColor(isUnlocked ? .white : .gray)
            
            Text(requirement)
                .font(.custom("TrebuchetMS", size: 11))
                .foregroundColor(.gray)
        }
        .frame(width: 110)
        .padding(.vertical, 15)
        .background(Color.siplyCardBackground)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isUnlocked ? Color.siplyJade.opacity(0.3) : Color.clear, lineWidth: 2)
        )
    }
}

// MARK: - Reward Model
struct Reward: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let pointsRequired: Int
    let description: String
    
    static let allRewards = [
        Reward(name: "Free Coffee", emoji: "☕️", pointsRequired: 50, description: "Get a free coffee at any partner cafe"),
        Reward(name: "Cocktail Discount", emoji: "🍹", pointsRequired: 100, description: "20% off any cocktail"),
        Reward(name: "VIP Pass", emoji: "👑", pointsRequired: 200, description: "Skip the line at partner bars"),
        Reward(name: "Free Drink", emoji: "🍸", pointsRequired: 300, description: "Any drink on the house"),
        Reward(name: "Premium Badge", emoji: "⭐️", pointsRequired: 500, description: "Show off your status"),
        Reward(name: "Exclusive Event", emoji: "🎉", pointsRequired: 1000, description: "Access to exclusive tastings")
    ]
}

// MARK: - Sips History View

struct SipsHistoryView: View {
    let totalSips: Int
    let drinksCount: Int
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.siplyBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Summary Card
                        VStack(spacing: 15) {
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Total Sips")
                                        .font(.custom("TrebuchetMS", size: 15))
                                        .foregroundColor(.gray)
                                    Text("\(totalSips)")
                                        .font(.custom("TrebuchetMS-Bold", size: 40))
                                        .fontWeight(.bold)
                                        .foregroundColor(.siplyJade)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 5) {
                                    Text("Drinks Logged")
                                        .font(.custom("TrebuchetMS", size: 15))
                                        .foregroundColor(.gray)
                                    Text("\(drinksCount)")
                                        .font(.custom("TrebuchetMS-Bold", size: 40))
                                        .fontWeight(.bold)
                                        .foregroundColor(.siplyMagenta)
                                }
                            }
                            
                            Divider()
                                .background(Color.gray.opacity(0.3))
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Bonus Sips")
                                        .font(.custom("TrebuchetMS", size: 13))
                                        .foregroundColor(.gray)
                                    Text("\(totalSips - drinksCount)")
                                        .font(.custom("TrebuchetMS-Bold", size: 24))
                                        .fontWeight(.bold)
                                        .foregroundColor(.yellow)
                                }
                                
                                Spacer()
                                
                                Text("From 5⭐ ratings")
                                    .font(.custom("TrebuchetMS", size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.siplyCardBackground)
                        .cornerRadius(20)
                        
                        // Info section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("How Sips Work")
                                .font(.custom("TrebuchetMS-Bold", size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            VStack(spacing: 12) {
                                InfoRow(icon: "cup.and.saucer.fill", text: "Get 1 sip for every drink you log", color: .siplyJade)
                                InfoRow(icon: "star.fill", text: "Earn bonus sips for 5-star ratings", color: .yellow)
                                InfoRow(icon: "arrow.up.circle.fill", text: "Level up every 10 sips", color: .siplyMagenta)
                                InfoRow(icon: "gift.fill", text: "Unlock rewards as you level up", color: .siplyLightBrown)
                            }
                        }
                        .padding()
                        .background(Color.siplyCardBackground)
                        .cornerRadius(20)
                    }
                    .padding()
                }
            }
            .navigationTitle("Sips History")
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
}

struct InfoRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
            }
            
            Text(text)
                .font(.custom("TrebuchetMS", size: 15))
                .foregroundColor(.white)
            
            Spacer()
        }
    }
}

#Preview {
    LoyaltyView()
        .environmentObject(DrinkManager())
}

