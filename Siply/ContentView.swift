//
//  ContentView.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var achievementManager = AchievementManager()
    @State private var selectedTab = 0
    @State private var previousTab = 0
    @State private var showCamera = false
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                    }
                    .tag(0)
                
                MapView()
                    .tabItem {
                        Image(systemName: "map.fill")
                    }
                    .tag(1)
                
                Color.clear
                    .tabItem {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 32))
                    }
                    .tag(2)
                
                DiscountsLandingView()
                    .tabItem {
                        Image(systemName: "tag.fill")
                    }
                    .tag(3)
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "book.fill")
                    }
                    .tag(4)
            }
            .accentColor(Color.siplyJade)
            .onChange(of: selectedTab) { oldValue, newValue in
                HapticManager.shared.selection()
                if newValue == 2 {
                    showCamera = true
                    selectedTab = previousTab
                } else {
                    previousTab = oldValue
                }
            }
            .environmentObject(achievementManager)
            .sheet(isPresented: $showCamera) {
                CameraAddDrinkView()
            }
            
            // Achievement popup
            if let achievement = achievementManager.showingAchievement {
                AchievementPopup(achievement: achievement, isShowing: Binding(
                    get: { achievementManager.showingAchievement != nil },
                    set: { if !$0 { achievementManager.showingAchievement = nil } }
                ))
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: achievementManager.showingAchievement)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DrinkManager())
        .environmentObject(LocationManager())
        .environmentObject(UserManager())
}
