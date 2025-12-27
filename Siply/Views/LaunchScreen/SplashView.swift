//
//  SplashView.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var ringRotation: Double = 0
    @State private var glowIntensity: Double = 0
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [
                    Color.siplyBackground,
                    Color.siplyCharcoal,
                    Color.siplyMagenta.opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if !isActive {
                VStack(spacing: 30) {
                    ZStack {
                        // Animated rings
                        ForEach(0..<3) { index in
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [Color.siplyJade.opacity(0.3), Color.siplyJade.opacity(0)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                                .frame(width: 150 + CGFloat(index * 30), height: 150 + CGFloat(index * 30))
                                .rotationEffect(.degrees(ringRotation + Double(index * 120)))
                        }
                        
                        // Glow effect
                        Circle()
                            .fill(Color.siplyJade.opacity(glowIntensity * 0.2))
                            .frame(width: 180, height: 180)
                            .blur(radius: 30)
                        
                        // Logo circle background
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.siplyJade.opacity(0.2),
                                        Color.siplyMagenta.opacity(0.2)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 150, height: 150)
                            .overlay(
                                Circle()
                                    .stroke(Color.siplyJade.opacity(0.5), lineWidth: 2)
                            )
                        
                        // S Letter (styled)
                        Text("S")
                            .font(.system(size: 80, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.siplyJade, Color.siplyJade.opacity(0.7)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .shadow(color: Color.siplyJade.opacity(0.5), radius: 10, x: 0, y: 0)
                    }
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    
                    // App name
                    VStack(spacing: 8) {
                        Text("Siply")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .opacity(logoOpacity)
                        
                        Text("Rate. Discover. Share.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .opacity(logoOpacity)
                    }
                }
                .onAppear {
                    // Logo animation
                    withAnimation(.easeOut(duration: 1.0)) {
                        logoScale = 1.0
                        logoOpacity = 1.0
                    }
                    
                    // Ring rotation
                    withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                        ringRotation = 360
                    }
                    
                    // Glow pulse
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        glowIntensity = 1.0
                    }
                    
                    // Transition to main app
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isActive = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}


