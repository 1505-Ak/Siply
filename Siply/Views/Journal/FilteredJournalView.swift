//
//  FilteredJournalView.swift
//  Siply
//
//  Filtered view by category
//

import SwiftUI

struct FilteredJournalView: View {
    let category: DrinkCategory
    @EnvironmentObject var drinkManager: DrinkManager
    @Environment(\.dismiss) var dismiss
    
    var filteredDrinks: [Drink] {
        drinkManager.drinks.filter { $0.category == category }
    }
    
    var body: some View {
        ZStack {
            Color.siplyBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.siplyJade)
                            .font(.title3)
                    }
                    
                    HStack(spacing: 8) {
                        Text(category.icon)
                            .font(.title2)
                        
                        Text(category.rawValue)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color.siplyCardBackground)
                
                // Content
                if filteredDrinks.isEmpty {
                    VStack(spacing: 20) {
                        Text(category.icon)
                            .font(.system(size: 80))
                        
                        Text("No \(category.rawValue) drinks yet")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text("Log your first \(category.rawValue) drink!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredDrinks) { drink in
                                NavigationLink(destination: DrinkDetailView(drink: drink)) {
                                    JournalDrinkCard(drink: drink)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

