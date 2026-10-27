//
//  CreateAccountView.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//

import SwiftUI

struct CreateAccountView: View {
    @Binding var isAuthenticated: Bool
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            Color.init("plantBackground").ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Create account").font(.largeTitle).fontWeight(.bold).foregroundColor(Color.init("plantText"))
                        Text("Join us to keep your plants happy.").font(.subheadline).foregroundColor(.gray)
                    }.padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Full Name").font(.headline).foregroundColor(Color.init("plantText"))
                        TextField("Maya Silva", text: $fullName).padding().background(Color(.systemBackground)).cornerRadius(10)
                            .textContentType(.name)
                        
                        Text("Email").font(.headline).foregroundColor(Color.init("plantText"))
                        TextField("you@example.com", text: $email)
                            .padding().background(Color(.systemBackground)).cornerRadius(10).keyboardType(.emailAddress).textInputAutocapitalization(.never).textContentType(.emailAddress)
                        
                        Text("Password").font(.headline).foregroundColor(Color.init("plantText"))
                        SecureField("••••••••", text: $password).padding().background(Color(.systemBackground)).cornerRadius(10)
                            .textContentType(.newPassword)
                    }
                    
                    if !errorMessage.isEmpty { Text(errorMessage).foregroundColor(.red).font(.footnote) }
                    
                    Button(action: {
                        Task {
                            isLoading = true; errorMessage = ""
                            do {
                                _ = try await AuthService.shared.createAccount(email: email, password: password)
                            } catch { errorMessage = error.localizedDescription }
                            isLoading = false
                        }
                    }) {
                        if isLoading {
                            ProgressView().tint(.white).frame(maxWidth: .infinity).padding()
                                .background(Color.plantPrimary).cornerRadius(12)
                        } else {
                            Text("Create Account").font(.headline).foregroundColor(.white).frame(maxWidth: .infinity)
                                .padding().background(Color.plantPrimary).cornerRadius(12)
                        }
                    }.disabled(isLoading)
                }.padding(.horizontal, 25)
            }
        }.navigationBarTitleDisplayMode(.inline)
    }
}

