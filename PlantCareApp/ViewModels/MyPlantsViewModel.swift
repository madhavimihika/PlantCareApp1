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
import FirebaseFirestore

class MyPlantsViewModel: ObservableObject {
    static let shared = MyPlantsViewModel()
    
    @Published var plants: [Plant] = []
    @Published var selectedFilter: String = "All"
    @Published var history: [CareHistoryItem] = []
    
    // Schedules and Growth Data -newone
    @Published var schedules: [String: CareSchedule] = [:]
    @Published var growthData: [String: [GrowthEntry]] = [:]
    
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
        logActivity(action: "Added Plant", plantName: name, icon: "leaf.fill", color: .green)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.loadPlantsFromCloud()
        }
    }
    
    func logActivity(action: String, plantName: String, icon: String, color: Color) {
        let newItem = CareHistoryItem(
            date: Date().formatted(date: .abbreviated, time: .shortened),
            action: action, plantName: plantName, icon: icon, color: color
        )
        history.insert(newItem, at: 0)
    }
    
    //CARE SCHEDULE LOGIC
    func getSchedule(for plant: Plant) -> CareSchedule {
        if let existing = schedules[plant.name] { return existing }
        let newSchedule = CareSchedule()
        DispatchQueue.main.async { self.schedules[plant.name] = newSchedule }
        return newSchedule
    }
    
    func daysUntilDue(_ kind: CareKind, for plant: Plant) -> Int {
        let schedule = getSchedule(for: plant)
        let lastDate = kind == .watering ? schedule.lastWatered : schedule.lastFertilized
        let interval = kind == .watering ? schedule.waterEveryDays : schedule.fertilizeEveryDays
        let nextDate = Calendar.current.date(byAdding: .day, value: interval, to: lastDate) ?? Date()
        let days = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: Calendar.current.startOfDay(for: nextDate)).day ?? 0
        return days
    }
    
    func nextDate(_ kind: CareKind, for plant: Plant) -> Date {
        let schedule = getSchedule(for: plant)
        let lastDate = kind == .watering ? schedule.lastWatered : schedule.lastFertilized
        let interval = kind == .watering ? schedule.waterEveryDays : schedule.fertilizeEveryDays
        return Calendar.current.date(byAdding: .day, value: interval, to: lastDate) ?? Date()
    }
    
    func interval(_ kind: CareKind, for plant: Plant) -> Int {
        let schedule = getSchedule(for: plant)
        return kind == .watering ? schedule.waterEveryDays : schedule.fertilizeEveryDays
    }
    
    func setInterval(_ newValue: Int, _ kind: CareKind, for plant: Plant) {
        var schedule = getSchedule(for: plant)
        if kind == .watering { schedule.waterEveryDays = max(kind.intervalRange.lowerBound, min(newValue, kind.intervalRange.upperBound)) }
        else { schedule.fertilizeEveryDays = max(kind.intervalRange.lowerBound, min(newValue, kind.intervalRange.upperBound)) }
        schedules[plant.name] = schedule
    }
    
    func markDone(_ kind: CareKind, for plant: Plant) {
        var schedule = getSchedule(for: plant)
        if kind == .watering { schedule.lastWatered = Date() } else { schedule.lastFertilized = Date() }
        schedules[plant.name] = schedule
        logActivity(action: kind.historyAction, plantName: plant.name, icon: kind.icon, color: kind.tint)
    }
    
    func dueCount(_ kind: CareKind) -> Int {
        plants.filter { daysUntilDue(kind, for: $0) <= 0 }.count
    }
    
    func plantsSorted(by kind: CareKind) -> [Plant] {
        plants.sorted { daysUntilDue(kind, for: $0) < daysUntilDue(kind, for: $1) }
    }
    
    //GROWTH DATA
    func growthEntries(for plant: Plant) -> [GrowthEntry] {
        return growthData[plant.name] ?? []
    }
    
    func addGrowth(height: Double, leaves: Int, for plant: Plant) {
        var entries = growthEntries(for: plant)
        entries.append(GrowthEntry(date: Date(), height: height, leaves: leaves))
        entries.sort { $0.date < $1.date }
        growthData[plant.name] = entries
    }
    
    func deleteGrowth(_ entry: GrowthEntry, for plant: Plant) {
        growthData[plant.name]?.removeAll { $0.id == entry.id }
    }
    
    //FILTERING
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

struct CareHistoryItem: Identifiable {
    let id = UUID()
    let date: String
    let action: String
    let plantName: String
    let icon: String
    let color: Color
}