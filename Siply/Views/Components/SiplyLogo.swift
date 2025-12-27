//
//  SiplyLogo.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI

struct SiplyLogo: View {
    let size: CGFloat
    let animated: Bool
    
    @State private var rotation: Double = 0
    @State private var glow: Double = 0
    
    init(size: CGFloat = 50, animated: Bool = false) {
        self.size = size
        self.animated = animated
    }
    
    var body: some View {
        ZStack {
            // Outer ring
            if animated {
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [Color.siplyJade.opacity(0.4), Color.siplyJade.opacity(0)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: size + 10, height: size + 10)
                    .rotationEffect(.degrees(rotation))
            }
            
            // Logo circle
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
                .frame(width: size, height: size)
                .overlay(
                    Circle()
                        .stroke(Color.siplyJade.opacity(0.5), lineWidth: 1.5)
                )
            
            // S Letter
            Text("S")
                .font(.system(size: size * 0.55, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.siplyJade, Color.siplyJade.opacity(0.8)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: Color.siplyJade.opacity(animated ? glow : 0.3), radius: 5, x: 0, y: 0)
        }
        .onAppear {
            if animated {
                withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    glow = 0.8
                }
            }
        }
    }
}

struct SiplyLogoWithText: View {
    let size: CGFloat
    
    init(size: CGFloat = 40) {
        self.size = size
    }
    
    var body: some View {
        HStack(spacing: 12) {
            SiplyLogo(size: size, animated: false)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Siply")
                    .font(.system(size: size * 0.6, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Rate. Discover. Share.")
                    .font(.system(size: size * 0.25))
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.siplyBackground.ignoresSafeArea()
        VStack(spacing: 40) {
            SiplyLogo(size: 100, animated: true)
            SiplyLogoWithText(size: 50)
        }
    }
}


