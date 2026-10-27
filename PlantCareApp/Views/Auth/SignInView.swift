//
//  SignInView.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//

import Foundation
import SwiftUI

struct SignInView: View {
    @Binding var isAuthenticated: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible = false
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    
    var body: some View {
        ZStack {
            Color.plantBackground.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome back").font(.largeTitle).fontWeight(.bold).foregroundColor(.plantText)
                        Text("Sign in to keep caring for your plants.").font(.subheadline).foregroundColor(.gray)
                    }.padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Email").font(.headline).foregroundColor(.plantText)
                        TextField("you@example.com", text: $email)
                            .padding().background(Color.white).cornerRadius(10).keyboardType(.emailAddress).autocapitalization(.none)
                        
                        Text("Password").font(.headline).foregroundColor(.plantText).padding(.top, 5)
                        HStack {
                            if isPasswordVisible { TextField("••••••••", text: $password) }
                            else { SecureField("••••••••", text: $password) }
                            Button(action: { isPasswordVisible.toggle() }) {
                                Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill").foregroundColor(.gray)
                            }
                        }.padding().background(Color.white).cornerRadius(10)
                    }
                    
                    if !errorMessage.isEmpty { Text(errorMessage).foregroundColor(.red).font(.footnote) }
                    
                    VStack(spacing: 15) {
                        Button(action: {
                            Task {
                                isLoading = true; errorMessage = ""
                                do {
                                    _ = try await AuthService.shared.signIn(email: email, password: password)
                                } catch { errorMessage = error.localizedDescription }
                                isLoading = false
                            }
                        }) {
                            if isLoading {
                                ProgressView().tint(.white).frame(maxWidth: .infinity).padding()
                                    .background(Color.plantPrimary).cornerRadius(12)
                            } else {
                                Text("Sign In").font(.headline).foregroundColor(.white).frame(maxWidth: .infinity)
                                    .padding().background(Color.plantPrimary).cornerRadius(12)
                            }
                        }.disabled(isLoading)
                    }
                }.padding(.horizontal, 25)
            }
        }.navigationBarTitleDisplayMode(.inline)
    }
}
