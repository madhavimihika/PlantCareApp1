//
//  WelcomeView.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//
import SwiftUI

struct WelcomeView: View {
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Beautiful gradient background
                LinearGradient(gradient: Gradient(colors: [Color.plantBackground, Color.white]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Image(systemName: "leaf.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.plantPrimary)
                            .shadow(color: Color.plantPrimary.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        Text("Plant Care")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.plantText)
                        
                        Text("Keep every plant happy")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.plantPrimary)
                        
                        Text("Care for every plant. Track growth, scan for diseases and never miss a watering.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 40)
                            .padding(.top, 10)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        NavigationLink(destination: SignInView(isAuthenticated: $isAuthenticated)) {
                            Text("Sign In")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.plantPrimary)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: Color.plantPrimary.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        
                        NavigationLink(destination: CreateAccountView(isAuthenticated: $isAuthenticated)) {
                            Text("Create Account")
                                .font(.headline)
                                .foregroundColor(.plantPrimary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.plantPrimary, lineWidth: 2))
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
        }
    }
}