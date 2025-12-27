//
//  AnimatedBackground.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI

struct AnimatedBackground: View {
    @State private var moveCircles = false
    
    var body: some View {
        ZStack {
            Color.siplyBackground.ignoresSafeArea()
            
            // Floating circles
            GeometryReader { geometry in
                ForEach(0..<5) { index in
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.siplyJade.opacity(0.05),
                                    Color.siplyMagenta.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: CGFloat.random(in: 100...200))
                        .offset(
                            x: moveCircles ? CGFloat.random(in: 0...geometry.size.width) : CGFloat.random(in: 0...geometry.size.width),
                            y: moveCircles ? CGFloat.random(in: 0...geometry.size.height) : CGFloat.random(in: 0...geometry.size.height)
                        )
                        .animation(
                            .easeInOut(duration: Double.random(in: 10...20))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.5),
                            value: moveCircles
                        )
                }
            }
            .blur(radius: 60)
        }
        .onAppear {
            moveCircles = true
        }
    }
}


