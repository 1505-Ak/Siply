//
//  AuthManager.swift
//  Siply
//
//  Created on December 28, 2025.
//

import Foundation
import Combine

class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: UserProfile?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Check if we have a valid token on init
        if let _ = UserDefaults.standard.string(forKey: "accessToken") {
            // Try to fetch current user
            getCurrentUser()
        }
    }
    
    func register(username: String, email: String, password: String, displayName: String) {
        isLoading = true
        errorMessage = nil
        
        APIClient.shared.register(username: username, email: email, password: password, displayName: displayName)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.handleAuthResponse(response)
            }
            .store(in: &cancellables)
    }
    
    func login(username: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        APIClient.shared.login(username: username, password: password)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.handleAuthResponse(response)
            }
            .store(in: &cancellables)
    }
    
    func logout() {
        APIClient.shared.clearAuthToken()
        isAuthenticated = false
        currentUser = nil
    }
    
    func getCurrentUser() {
        APIClient.shared.getCurrentUser()
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print("Failed to get current user: \(error.localizedDescription)")
                    // If token is invalid, logout
                    self?.logout()
                }
            } receiveValue: { [weak self] user in
                self?.currentUser = user
                self?.isAuthenticated = true
            }
            .store(in: &cancellables)
    }
    
    func refreshToken() {
        APIClient.shared.refreshAccessToken()
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print("Failed to refresh token: \(error.localizedDescription)")
                    self?.logout()
                }
            } receiveValue: { [weak self] response in
                self?.handleAuthResponse(response)
            }
            .store(in: &cancellables)
    }
    
    private func handleAuthResponse(_ response: AuthResponse) {
        APIClient.shared.setAuthTokens(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken
        )
        currentUser = response.user
        isAuthenticated = true
    }
}

