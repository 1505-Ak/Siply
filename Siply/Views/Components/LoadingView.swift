//
//  LoadingView.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.siplyJade)
                        .frame(width: 20, height: 20)
                        .scaleEffect(isAnimating ? 1.0 : 0.5)
                        .opacity(isAnimating ? 0.3 : 1.0)
                        .animation(
                            .easeInOut(duration: 1.0)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                            value: isAnimating
                        )
                        .offset(x: CGFloat(index - 1) * 30)
                }
            }
            
            Text("Loading...")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(icon: String, title: String, message: String, actionTitle: String? = nil, action: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(icon)
                .font(.system(size: 80))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.siplyCharcoal)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color.siplyJade)
                        .cornerRadius(25)
                }
                .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


