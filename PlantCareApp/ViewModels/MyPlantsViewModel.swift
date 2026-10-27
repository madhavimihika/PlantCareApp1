//
//  MyPlantsViewModel.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//
//
//  MyPlantsViewModel.swift
//  PlantCareApp
//
//
//  MyPlantsViewModel.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//

import SwiftUI
import Combine

class MyPlantsViewModel: ObservableObject {
    static let shared = MyPlantsViewModel()
    
    // Use empty array (Firebase fill this
    @Published var plants: [Plant] = []
    @Published var selectedFilter: String = "All"
    
    init() {
        loadPlantsFromCloud()
    }
    
    func loadPlantsFromCloud() {
        FirebaseService.shared.fetchPlants { fetchedPlants in
            DispatchQueue.main.async {
                self.plants = fetchedPlants
            }
        }
    }
    
    func addPlant(name: String, botanicalName: String, location: String) {
        FirebaseService.shared.savePlant(name: name, botanicalName: botanicalName, location: location)
        
        // Wait for Firestore to save, then reload the list
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.loadPlantsFromCloud()
        }
    }
    
    var filteredPlants: [Plant] {
        switch selectedFilter {
        case "Healthy": return plants.filter { $0.health == .healthy }
        case "Need care": return plants.filter { $0.health == .needsCare }
        default: return plants
        }
    }
    
    var allCount: Int { plants.count }
    var healthyCount: Int { plants.filter { $0.health == .healthy }.count }
    var needsCareCount: Int { plants.filter { $0.health == .needsCare }.count }
}
