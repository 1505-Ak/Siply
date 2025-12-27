//
//  NavigationBackButton.swift
//  Siply
//
//  Back button for navigation
//

import SwiftUI

struct NavigationBackButton: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(action: {
            dismiss()
            HapticManager.shared.impact(style: .light)
        }) {
            HStack(spacing: 6) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.siplyJade)
                
                Text("Back")
                    .font(.custom("TrebuchetMS", size: 16))
                    .foregroundColor(.siplyJade)
            }
        }
    }
}

#Preview {
    NavigationBackButton()
}


