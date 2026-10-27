//
//  AuthService.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//
import Foundation
import FirebaseAuth

class AuthService {
    static let shared = AuthService()
    
    func signIn(email: String, password: String) async throws -> User {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return authResult.user
    }
    
    func createAccount(email: String, password: String) async throws -> User {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return authResult.user
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
