//
//  SettingsView.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var drinkManager: DrinkManager
    @Environment(\.dismiss) var dismiss
    
    @State private var displayName = ""
    @State private var showingResetAlert = false
    @State private var showingDeleteAlert = false
    @State private var showingExportSuccess = false
    @State private var showingRestoreSuccess = false
    @State private var notificationsEnabled = true
    @State private var locationEnabled = true
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.siplyBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Profile Section
                        profileSection
                        
                        // Data Management Section
                        dataManagementSection
                        
                        // Privacy Section
                        privacySection
                        
                        // Notifications Section
                        notificationsSection
                        
                        // About Section
                        aboutSection
                        
                        // Danger Zone
                        dangerZoneSection
                    }
                    .padding()
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
            .alert("Reset Data?", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    userManager.resetUser()
                    HapticManager.shared.notification(type: .success)
                }
            } message: {
                Text("This will reset your profile to default. Your drinks will not be affected.")
            }
            .alert("Delete All Drinks?", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete All", role: .destructive) {
                    drinkManager.clearAllData()
                    HapticManager.shared.notification(type: .warning)
                }
            } message: {
                Text("This will permanently delete all your logged drinks. This cannot be undone!")
            }
            .alert("Success", isPresented: $showingExportSuccess) {
                Button("OK") {}
            } message: {
                Text("Your data has been backed up successfully!")
            }
            .alert("Restored", isPresented: $showingRestoreSuccess) {
                Button("OK") {}
            } message: {
                Text("Your data has been restored from backup!")
            }
            .onAppear {
                displayName = userManager.currentUser?.displayName ?? ""
            }
        }
    }
    
    private var profileSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Profile")
                .font(.headline)
                .foregroundColor(.gray)
            
            VStack(spacing: 12) {
                HStack {
                    Text("Display Name")
                        .foregroundColor(.white)
                    Spacer()
                    TextField("Your name", text: $displayName)
                        .foregroundColor(.siplyJade)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: displayName) { oldValue, newValue in
                            userManager.updateDisplayName(newValue)
                        }
                }
                .padding()
                .background(Color.siplyCardBackground)
                .cornerRadius(12)
                
                HStack {
                    Text("Username")
                        .foregroundColor(.white)
                    Spacer()
                    Text("@\(userManager.currentUser?.username ?? "user")")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.siplyCardBackground)
                .cornerRadius(12)
            }
        }
    }
    
    private var dataManagementSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Data Management")
                .font(.headline)
                .foregroundColor(.gray)
            
            VStack(spacing: 12) {
                Button(action: {
                    if drinkManager.exportData() != nil {
                        showingExportSuccess = true
                        HapticManager.shared.notification(type: .success)
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.up.doc.fill")
                            .foregroundColor(.siplyJade)
                        Text("Backup Data")
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.siplyCardBackground)
                    .cornerRadius(12)
                }
                
                Button(action: {
                    if drinkManager.restoreFromBackup() {
                        showingRestoreSuccess = true
                        HapticManager.shared.notification(type: .success)
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.down.doc.fill")
                            .foregroundColor(.siplyJade)
                        Text("Restore from Backup")
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.siplyCardBackground)
                    .cornerRadius(12)
                }
                
                // Statistics
                VStack(alignment: .leading, spacing: 8) {
                    Text("Storage Info")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Text("Total Drinks:")
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(drinkManager.getTotalDrinks())")
                            .foregroundColor(.siplyJade)
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Text("Total Spent:")
                            .foregroundColor(.white)
                        Spacer()
                        Text("$\(String(format: "%.2f", drinkManager.getTotalSpent()))")
                            .foregroundColor(.siplyJade)
                            .fontWeight(.semibold)
                    }
                    
                    if let mostVisited = drinkManager.getMostVisitedLocation() {
                        HStack {
                            Text("Most Visited:")
                                .foregroundColor(.white)
                            Spacer()
                            Text(mostVisited)
                                .foregroundColor(.siplyJade)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                        }
                    }
                }
                .padding()
                .background(Color.siplyCardBackground)
                .cornerRadius(12)
            }
        }
    }
    
    private var privacySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Privacy")
                .font(.headline)
                .foregroundColor(.gray)
            
            VStack(spacing: 12) {
                Toggle(isOn: $locationEnabled) {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.siplyJade)
                        Text("Location Services")
                            .foregroundColor(.white)
                    }
                }
                .tint(.siplyJade)
                .padding()
                .background(Color.siplyCardBackground)
                .cornerRadius(12)
                
                NavigationLink(destination: PrivacySettingsView()) {
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.siplyJade)
                        Text("Privacy Settings")
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.siplyCardBackground)
                    .cornerRadius(12)
                }
                
                NavigationLink(destination: BlockedUsersView()) {
                    HStack {
                        Image(systemName: "eye.slash.fill")
                            .foregroundColor(.siplyJade)
                        Text("Blocked Users")
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.siplyCardBackground)
                    .cornerRadius(12)
                }
            }
        }
    }
    
    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notifications")
                .font(.headline)
                .foregroundColor(.gray)
            
            VStack(spacing: 12) {
                Toggle(isOn: $notificationsEnabled) {
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.siplyJade)
                        Text("Push Notifications")
                            .foregroundColor(.white)
                    }
                }
                .tint(.siplyJade)
                .padding()
                .background(Color.siplyCardBackground)
                .cornerRadius(12)
            }
        }
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(.headline)
                .foregroundColor(.gray)
            
            VStack(spacing: 12) {
                NavigationLink(destination: AboutView()) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.siplyJade)
                        Text("About Siply")
                            .foregroundColor(.white)
                        Spacer()
                        Text("v1.0.0")
                            .foregroundColor(.gray)
                            .font(.caption)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.siplyCardBackground)
                    .cornerRadius(12)
                }
                
                NavigationLink(destination: TermsView()) {
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .foregroundColor(.siplyJade)
                        Text("Terms & Privacy")
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.siplyCardBackground)
                    .cornerRadius(12)
                }
            }
        }
    }
    
    private var dangerZoneSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Danger Zone")
                .font(.headline)
                .foregroundColor(.red)
            
            VStack(spacing: 12) {
                Button(action: { showingResetAlert = true }) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(.orange)
                        Text("Reset Profile")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .background(Color.siplyCardBackground)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                    )
                }
                
                Button(action: { showingDeleteAlert = true }) {
                    HStack {
                        Image(systemName: "trash.fill")
                            .foregroundColor(.red)
                        Text("Delete All Drinks")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .background(Color.siplyCardBackground)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                    )
                }
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "arrow.right.square.fill")
                            .foregroundColor(.red)
                        Text("Log Out")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding()
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.red.opacity(0.5), lineWidth: 1)
                    )
                }
            }
        }
    }
}

// Placeholder views for navigation
struct PrivacySettingsView: View {
    var body: some View {
        ZStack {
            Color.siplyBackground.ignoresSafeArea()
            Text("Privacy Settings")
                .foregroundColor(.white)
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BlockedUsersView: View {
    var body: some View {
        ZStack {
            Color.siplyBackground.ignoresSafeArea()
            VStack(spacing: 16) {
                Image(systemName: "eye.slash")
                    .font(.system(size: 50))
                    .foregroundColor(.gray)
                Text("No Blocked Users")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Users you block will appear here")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Blocked Users")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView: View {
    var body: some View {
        ZStack {
            Color.siplyBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    SiplyLogo(size: 80, animated: true)
                    
                    Text("Siply")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Version 1.0.0")
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("About")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("Siply is your personal drink journal and discovery app. Track, rate, and discover amazing drinks from around the world.")
                            .foregroundColor(.gray)
                            .lineSpacing(4)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.siplyCardBackground)
                    .cornerRadius(12)
                    
                    VStack(spacing: 12) {
                        Link(destination: URL(string: "https://siply.app")!) {
                            HStack {
                                Image(systemName: "link")
                                Text("Website")
                                Spacer()
                                Image(systemName: "arrow.up.right")
                            }
                            .foregroundColor(.siplyJade)
                            .padding()
                            .background(Color.siplyCardBackground)
                            .cornerRadius(12)
                        }
                        
                        Link(destination: URL(string: "mailto:support@siply.app")!) {
                            HStack {
                                Image(systemName: "envelope")
                                Text("Support")
                                Spacer()
                                Image(systemName: "arrow.up.right")
                            }
                            .foregroundColor(.siplyJade)
                            .padding()
                            .background(Color.siplyCardBackground)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("About Siply")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TermsView: View {
    var body: some View {
        ZStack {
            Color.siplyBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Terms of Service")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Last updated: October 4, 2025")
                        .foregroundColor(.gray)
                        .font(.caption)
                    
                    Group {
                        sectionTitle("1. Acceptance of Terms")
                        sectionText("By using Siply, you agree to these terms and conditions.")
                        
                        sectionTitle("2. User Content")
                        sectionText("You retain rights to your content. We store your drink logs locally on your device.")
                        
                        sectionTitle("3. Privacy")
                        sectionText("We respect your privacy. Location data is only used to enhance your experience and is stored locally.")
                        
                        sectionTitle("4. Changes to Terms")
                        sectionText("We may update these terms from time to time. Continued use constitutes acceptance.")
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Terms & Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.white)
            .padding(.top, 8)
    }
    
    private func sectionText(_ text: String) -> some View {
        Text(text)
            .foregroundColor(.gray)
            .lineSpacing(4)
    }
}


