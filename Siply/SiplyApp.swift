//
//  SiplyApp.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI

@main
struct SiplyApp: App {
    @StateObject private var drinkManager = DrinkManager()
    @StateObject private var locationManager = LocationManager()
    @StateObject private var userManager = UserManager()
    @StateObject private var venueManager = VenueManager()
    
    init() {
        // Set custom font family - Plus Jakarta Sans or fallback to Trebuchet MS
        if let plusJakartaSans = UIFont(name: "PlusJakartaSans-Regular", size: 17) {
            UILabel.appearance().font = plusJakartaSans
        } else if let trebuchet = UIFont(name: "TrebuchetMS", size: 17) {
            UILabel.appearance().font = trebuchet
        }
        
        // Configure navigation bar appearance for better visibility
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.siplyBackground)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        // Configure clean tab bar matching app theme
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        
        // Dark charcoal background to match app theme
        tabAppearance.backgroundColor = UIColor(red: 60/255, green: 64/255, blue: 68/255, alpha: 1.0)
        
        // Selected tab - jade green
        let selectedColor = UIColor(red: 208/255, green: 255/255, blue: 20/255, alpha: 1.0)
        tabAppearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        
        // Normal tab - white
        tabAppearance.stackedLayoutAppearance.normal.iconColor = .white
        
        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(drinkManager)
                .environmentObject(locationManager)
                .environmentObject(userManager)
                .environmentObject(venueManager)
                .preferredColorScheme(.dark)
        }
    }
}

struct SplashScreenView: View {
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .transition(.opacity)
            } else {
                ContentView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showSplash = false
                }
            }
        }
    }
}
