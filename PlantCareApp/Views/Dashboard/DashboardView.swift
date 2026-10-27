//
//  DashboardView.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//
import SwiftUI
import Combine
import FirebaseAuth // <-- Important for Auth

class DashboardViewModel: ObservableObject {
    @Published var userName = "User" // Default fallback
    @Published var gardenHealth = 82
    @Published var healthyCount = 4
    @Published var needCareCount = 2
    @Published var diseaseCount = 1
    
    @Published var careTasks: [CareTask] = [
        CareTask(plantName: "Croton", botanicalName: "Monstera", location: "Living room", isCompleted: false),
        CareTask(plantName: "Pothos", botanicalName: "Ficus lyrata", location: "Bedroom", isCompleted: false)
    ]
    
    init() {
        fetchUserName()
    }
    
    func fetchUserName() {
        if let user = Auth.auth().currentUser {
            // 1. If the user set a display name during sign-up, use it
            if let displayName = user.displayName, !displayName.isEmpty {
                self.userName = displayName
            }
            // 2. Otherwise, grab the email and take the part before the '@'
            else if let email = user.email {
                let namePart = email.components(separatedBy: "@").first ?? "User"
                // Capitalize the first letter (e.g., "maya" -> "Maya")
                self.userName = namePart.prefix(1).uppercased() + namePart.dropFirst()
            }
        }
    }
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Good morning" }
        else if hour < 17 { return "Good afternoon" }
        else { return "Good evening" }
    }
    
    var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.string(from: Date())
    }
}