//
//  ProfileView.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var drinkManager: DrinkManager
    @EnvironmentObject var achievementManager: AchievementManager
    @State private var showingEditProfile = false
    @State private var showingAchievements = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.siplyBackground.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Custom header with coffee brown ribbon
                        customHeader
                        
                        VStack(spacing: 20) {
                            // Profile Header
                            profileHeader
                            
                            // Social Stats (Followers/Following)
                            socialStatsSection
                            
                            // Quick Stats Grid
                            quickStatsGrid
                            
                            // Quick Actions
                            quickActionsSection
                            
                            // Achievements Section
                            achievementsSection
                        }
                        .padding()
                        .padding(.top, 10)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingEditProfile) {
                SettingsView()
            }
            .sheet(isPresented: $showingAchievements) {
                AchievementsView()
            }
        }
    }
    
    private var customHeader: some View {
        VStack(spacing: 0) {
            // Coffee brown ribbon on top
            Rectangle()
                .fill(Color.siplyLightBrown)
                .frame(height: 4)
            
            HStack {
                Text("Profile")
                    .font(.custom("TrebuchetMS-Bold", size: 28))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: { showingEditProfile = true }) {
                    ZStack {
                        Circle()
                            .fill(Color.siplyLightBrown.opacity(0.3))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.siplyJade)
                            .font(.system(size: 18))
                    }
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
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            // Profile Picture with Siply branding
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.siplyMagenta, Color.siplyJade],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .overlay(
                        Text(String(userManager.currentUser?.displayName.prefix(1) ?? "U"))
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                    )
                
                // Small Siply badge
                SiplyLogo(size: 28, animated: false)
                    .offset(x: 35, y: 35)
            }
            
            // Name and Username
            VStack(spacing: 4) {
                Text(userManager.currentUser?.displayName ?? "User")
                    .font(.custom("TrebuchetMS-Bold", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("@\(userManager.currentUser?.username ?? "username")")
                    .font(.custom("TrebuchetMS", size: 15))
                    .foregroundColor(.gray)
            }
        }
    }
    
    private var quickStatsGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Stats")
                .font(.custom("TrebuchetMS-Bold", size: 20))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ProfileStatCard(
                    icon: "cup.and.saucer.fill",
                    title: "Drinks",
                    value: "\(drinkManager.getTotalDrinks())",
                    color: .siplyJade
                )
                
                ProfileStatCard(
                    icon: "star.fill",
                    title: "Avg Rating",
                    value: String(format: "%.1f", drinkManager.getAverageRating()),
                    color: .yellow
                )
                
                ProfileStatCard(
                    icon: "building.2.fill",
                    title: "Cities",
                    value: "\(getCitiesCount())",
                    color: .siplyMagenta
                )
                
                ProfileStatCard(
                    icon: "globe",
                    title: "Countries",
                    value: "\(getCountriesCount())",
                    color: .siplyLightBrown
                )
            }
        }
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.custom("TrebuchetMS-Bold", size: 20))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                NavigationLink(destination: JournalView()) {
                    QuickActionCard(
                        icon: "book.fill",
                        title: "My Journal",
                        subtitle: "\(drinkManager.drinks.count) drinks",
                        color: .siplyJade
                    )
                }
                
                if let favDrink = drinkManager.getFavoriteDrinks().first {
                    QuickActionCard(
                        icon: "heart.fill",
                        title: "Signature Drink",
                        subtitle: favDrink.name,
                        color: .siplyMagenta
                    )
                } else {
                    QuickActionCard(
                        icon: "heart.fill",
                        title: "Signature Drink",
                        subtitle: "Not set yet",
                        color: .gray
                    )
                }
                
                NavigationLink(destination: PersonalMapView()) {
                    QuickActionCard(
                        icon: "map.fill",
                        title: "My Map",
                        subtitle: "View your drink locations",
                        color: .siplyLightBrown
                    )
                }
            }
        }
    }
    
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Achievements")
                    .font(.custom("TrebuchetMS-Bold", size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: { showingAchievements = true }) {
                    HStack(spacing: 4) {
                        Text("View All")
                            .font(.custom("TrebuchetMS", size: 13))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10))
                    }
                    .foregroundColor(.siplyJade)
                }
            }
            
            if achievementManager.unlockedAchievements.isEmpty {
                // Empty state
                VStack(spacing: 12) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("No achievements yet")
                        .font(.custom("TrebuchetMS", size: 15))
                        .foregroundColor(.gray)
                    
                    Text("Start logging drinks to unlock achievements!")
                        .font(.custom("TrebuchetMS", size: 13))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .background(Color.siplyCardBackground)
                .cornerRadius(15)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(achievementManager.unlockedAchievements.prefix(6)), id: \.self) { achievement in
                            AchievementBadge(achievement: achievement, isUnlocked: true)
                        }
                    }
                }
            }
        }
    }
    
    private var socialStatsSection: some View {
        HStack(spacing: 12) {
            NavigationLink(destination: FollowersView()) {
                ProfileSocialCard(
                    value: "\(userManager.currentUser?.followersCount ?? 0)",
                    label: "Followers"
                )
            }
            
            NavigationLink(destination: FollowingView()) {
                ProfileSocialCard(
                    value: "\(userManager.currentUser?.followingCount ?? 0)",
                    label: "Following"
                )
            }
        }
    }
    
    private func getCitiesCount() -> Int {
        // Extract unique cities from drink locations
        let citiesArray = drinkManager.drinks.compactMap { drink -> String? in
            guard !drink.locationName.isEmpty else { return nil }
            // Get the first part before comma as city
            return drink.locationName.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespaces)
        }.filter { !$0.isEmpty }
        return Set(citiesArray).count
    }
    
    private func getCountriesCount() -> Int {
        // Extract unique countries from drink locations
        let countriesArray = drinkManager.drinks.compactMap { drink -> String? in
            guard !drink.locationName.isEmpty else { return nil }
            let components = drink.locationName.components(separatedBy: ",")
            // Get the last part as country
            if components.count > 1 {
                return components.last?.trimmingCharacters(in: .whitespaces)
            }
            return nil
        }.filter { !$0.isEmpty }
        return Set(countriesArray).count
    }
    
}

struct StatColumn: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct StatsCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.siplyCardBackground)
        .cornerRadius(12)
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.siplyJade)
                    .frame(width: 24)
                Text(title)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            .padding()
            .background(Color.siplyCardBackground)
            .cornerRadius(8)
        }
    }
}

struct EditProfileView: View {
    @EnvironmentObject var userManager: UserManager
    @Environment(\.dismiss) var dismiss
    @State private var displayName = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.siplyBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Settings List
                    ScrollView {
                        VStack(spacing: 20) {
                            // Profile Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Profile")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                
                                SettingsRow(icon: "person.fill", title: "Edit Name", value: displayName)
                                SettingsRow(icon: "at", title: "Username", value: "@\(userManager.currentUser?.username ?? "")")
                            }
                            
                            // Privacy Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Privacy")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                
                                SettingsRow(icon: "lock.fill", title: "Privacy Settings", value: "")
                                SettingsRow(icon: "eye.slash.fill", title: "Blocked Users", value: "")
                            }
                            
                            // Notifications
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Notifications")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                
                                SettingsRow(icon: "bell.fill", title: "Push Notifications", value: "")
                                SettingsRow(icon: "envelope.fill", title: "Email", value: "")
                            }
                            
                            // About
                            VStack(alignment: .leading, spacing: 12) {
                                Text("About")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                
                                SettingsRow(icon: "info.circle.fill", title: "About Siply", value: "")
                                SettingsRow(icon: "doc.text.fill", title: "Terms & Privacy", value: "")
                            }
                            
                            // Logout Button
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "arrow.right.square.fill")
                                        .foregroundColor(.red)
                                    Text("Log Out")
                                        .fontWeight(.semibold)
                                    Spacer()
                                }
                                .foregroundColor(.red)
                                .padding()
                                .background(Color.siplyCardBackground)
                                .cornerRadius(12)
                            }
                            .padding(.horizontal)
                            .padding(.top, 20)
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Settings")
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
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.siplyJade)
                .frame(width: 24)
            
            Text(title)
                .foregroundColor(.white)
            
            Spacer()
            
            if !value.isEmpty {
                Text(value)
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.siplyCardBackground)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// Placeholder views for navigation
struct FollowersView: View {
    var body: some View {
        ZStack {
            Color.siplyBackground.ignoresSafeArea()
            Text("Followers")
                .foregroundColor(.white)
        }
        .navigationTitle("Followers")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FollowingView: View {
    var body: some View {
        ZStack {
            Color.siplyBackground.ignoresSafeArea()
            Text("Following")
                .foregroundColor(.white)
        }
        .navigationTitle("Following")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - V2 Profile Components

struct ProfileStatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(.custom("TrebuchetMS-Bold", size: 24))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.custom("TrebuchetMS", size: 13))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.siplyCardBackground)
        .cornerRadius(15)
    }
}

struct QuickActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("TrebuchetMS-Bold", size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.custom("TrebuchetMS", size: 13))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.siplyCardBackground)
        .cornerRadius(15)
    }
}

struct ProfileSocialCard: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.custom("TrebuchetMS-Bold", size: 28))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(label)
                .font(.custom("TrebuchetMS", size: 14))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            LinearGradient(
                colors: [Color.siplyMagenta.opacity(0.3), Color.siplyJade.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .background(Color.siplyCardBackground)
        .cornerRadius(15)
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserManager())
        .environmentObject(DrinkManager())
        .environmentObject(AchievementManager())
}
