//
//  AuthView.swift
//  Siply
//
//  Created on December 28, 2025.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var isLogin = true
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.siplyBackground, Color.siplyBackground.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Logo
                VStack(spacing: 15) {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                    
                    Text("Siply")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Track your drinks, discover new venues")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 60)
                
                Spacer()
                
                // Auth form
                if isLogin {
                    LoginForm()
                } else {
                    RegisterForm()
                }
                
                // Toggle between login and register
                Button(action: {
                    withAnimation {
                        isLogin.toggle()
                    }
                }) {
                    HStack {
                        Text(isLogin ? "Don't have an account?" : "Already have an account?")
                            .foregroundColor(.gray)
                        Text(isLogin ? "Sign Up" : "Sign In")
                            .foregroundColor(.siplyJade)
                            .fontWeight(.semibold)
                    }
                    .font(.subheadline)
                }
                .padding(.bottom, 30)
            }
        }
    }
}

struct LoginForm: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Username")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                TextField("", text: $username)
                    .textFieldStyle(SiplyTextFieldStyle())
                    .autocapitalization(.none)
                    .textContentType(.username)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                SecureField("", text: $password)
                    .textFieldStyle(SiplyTextFieldStyle())
                    .textContentType(.password)
            }
            
            if let error = authManager.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                authManager.login(username: username, password: password)
            }) {
                if authManager.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Sign In")
                        .fontWeight(.semibold)
                }
            }
            .buttonStyle(SiplyPrimaryButtonStyle())
            .disabled(username.isEmpty || password.isEmpty || authManager.isLoading)
        }
        .padding(.horizontal, 30)
    }
}

struct RegisterForm: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var username = ""
    @State private var email = ""
    @State private var displayName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var isValid: Bool {
        !username.isEmpty && 
        !email.isEmpty && 
        !displayName.isEmpty && 
        !password.isEmpty && 
        password == confirmPassword &&
        password.count >= 8
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Username")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    TextField("", text: $username)
                        .textFieldStyle(SiplyTextFieldStyle())
                        .autocapitalization(.none)
                        .textContentType(.username)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    TextField("", text: $email)
                        .textFieldStyle(SiplyTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Display Name")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    TextField("", text: $displayName)
                        .textFieldStyle(SiplyTextFieldStyle())
                        .textContentType(.name)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    SecureField("", text: $password)
                        .textFieldStyle(SiplyTextFieldStyle())
                        .textContentType(.newPassword)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Confirm Password")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    SecureField("", text: $confirmPassword)
                        .textFieldStyle(SiplyTextFieldStyle())
                        .textContentType(.newPassword)
                }
                
                if password != confirmPassword && !confirmPassword.isEmpty {
                    Text("Passwords do not match")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                if !password.isEmpty && password.count < 8 {
                    Text("Password must be at least 8 characters")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                
                if let error = authManager.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                
                Button(action: {
                    authManager.register(
                        username: username,
                        email: email,
                        password: password,
                        displayName: displayName
                    )
                }) {
                    if authManager.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Create Account")
                            .fontWeight(.semibold)
                    }
                }
                .buttonStyle(SiplyPrimaryButtonStyle())
                .disabled(!isValid || authManager.isLoading)
            }
            .padding(.horizontal, 30)
        }
    }
}

// MARK: - Custom Styles

struct SiplyTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
            .foregroundColor(.white)
    }
}

struct SiplyPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(configuration.isPressed ? Color.siplyJade.opacity(0.8) : Color.siplyJade)
            .foregroundColor(.black)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthManager())
}

