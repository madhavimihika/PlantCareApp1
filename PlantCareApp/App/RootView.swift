//
//  RootView.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//
import SwiftUI
import FirebaseAuth

struct RootView: View {
    @State private var user: User? = Auth.auth().currentUser
    @State private var isLoggedIn = false
    
    // add the Face ID state
    @State private var isUnlocked = false
    
    var body: some View {
        Group {
            if user != nil {
                // Check if the user is unlocked
                if isUnlocked {
                    MainTabView()
                } else {
                    FaceIDView(isUnlocked: $isUnlocked)
                }
            } else {
                WelcomeView(isAuthenticated: $isLoggedIn)
            }
        }
        .id(user?.uid ?? "guest")
        .onAppear {
            _ = Auth.auth().addStateDidChangeListener { _, firebaseUser in
                self.user = firebaseUser
                
                // Trigger Face ID automatically when the app opens
                if firebaseUser != nil {
                    BiometricService.shared.authenticateUser { success in
                        if success {
                            self.isUnlocked = true
                        }
                    }
                }
            }
        }
    }
}