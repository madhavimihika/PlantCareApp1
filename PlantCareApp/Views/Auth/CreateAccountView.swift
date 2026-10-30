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
            Color.plantBackground.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Create account").font(.largeTitle).fontWeight(.bold).foregroundColor(.plantText)
                        Text("Join us to keep your plants happy.").font(.subheadline).foregroundColor(.black)
                    }.padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Full Name").font(.headline).foregroundColor(.plantText)
                        TextField("Maya Silva", text: $fullName)
                            .padding()
                            .background(Color.white) // <-- FIX: Changed from systemBackground
                            .cornerRadius(10)
                            .foregroundColor(.black) // <-- FIX: Force black text
                        
                        Text("Email").font(.headline).foregroundColor(.plantText)
                        TextField("you@example.com", text: $email)
                            .padding()
                            .background(Color.white) // <-- FIX
                            .cornerRadius(10)
                            .foregroundColor(.black) // <-- FIX
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                        
                        Text("Password").font(.headline).foregroundColor(.plantText)
                        SecureField("••••••••", text: $password)
                            .padding()
                            .background(Color.white) // <-- FIX
                            .cornerRadius(10)
                            .foregroundColor(.black) // <-- FIX
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
                            Text("Create Account").font(.headline).foregroundColor(.black).frame(maxWidth: .infinity)
                                .padding().background(Color.plantPrimary).cornerRadius(12)
                        }
                    }.disabled(isLoading)
                }.padding(.horizontal, 25)
            }
        }.navigationBarTitleDisplayMode(.inline)
    }
}