//
//  RootView.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct RootView: View {
    @State private var user: User? = Auth.auth().currentUser
    @State private var isLoggedIn = false
    
    var body: some View {
        Group {
            if user != nil {
                MainTabView()
            } else {
                WelcomeView(isAuthenticated: $isLoggedIn)
            }
        }
        .id(user?.uid ?? "guest")
        .onAppear {
            _ = Auth.auth().addStateDidChangeListener { _, firebaseUser in
                self.user = firebaseUser
            }
        }
    }
}
