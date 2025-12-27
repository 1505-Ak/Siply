//
//  CityPickerView.swift
//  Siply
//
//  Created on October 4, 2025.
//

import SwiftUI

struct CityPickerView: View {
    @Binding var selectedCity: String
    let cities: [String]
    let onCitySelected: (String) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.siplyBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom header
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.black)
                            .frame(height: 1)
                        
                        HStack {
                            Text("Select Location")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button("Done") {
                                dismiss()
                            }
                            .foregroundColor(.siplyJade)
                            .fontWeight(.semibold)
                        }
                        .padding()
                        .background(Color.siplyBackground)
                    }
                    
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        Text("Search cities...")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding()
                    .background(Color.siplyCardBackground)
                    .cornerRadius(12)
                    .padding()
                    
                    // Cities list
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(cities, id: \.self) { city in
                                Button(action: {
                                    selectedCity = city
                                    onCitySelected(city)
                                    HapticManager.shared.selection()
                                    dismiss()
                                }) {
                                    HStack {
                                        Image(systemName: "mappin.circle.fill")
                                            .foregroundColor(.siplyJade)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(city.components(separatedBy: ",").first ?? city)
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            Text(city.components(separatedBy: ",").last ?? "")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        if city == selectedCity {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.siplyJade)
                                        }
                                    }
                                    .padding()
                                    .background(city == selectedCity ? Color.siplyJade.opacity(0.1) : Color.siplyCardBackground)
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}
