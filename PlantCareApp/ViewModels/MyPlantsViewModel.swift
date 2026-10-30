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
import SwiftUI
import Combine
import FirebaseAuth

// How a plant is doing, worked out from its care schedule
enum GardenStatus {
    case healthy, needsCare, atRisk
}

class MyPlantsViewModel: ObservableObject {

    static let shared = MyPlantsViewModel()

    @Published var history: [CareHistoryItem] = []
    @Published var plants: [Plant] = []          // filled by Firebase
    @Published var selectedFilter: String = "All"

    // Care data, saved on the phone, separate for each signed-in user
    @Published private(set) var schedules: [String: CareSchedule] = [:]
    @Published private(set) var growth: [String: [GrowthEntry]] = [:]

    private var currentUID: String?
    private var authHandle: AuthStateDidChangeListenerHandle?

    private var schedulesKey: String { "careSchedules.v2.\(currentUID ?? "guest")" }
    private var growthKey: String { "growthRecords.v2.\(currentUID ?? "guest")" }

    init() {
        // Runs now, and again every time someone signs in or out
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.userChanged(to: user?.uid)
        }
    }

    // Switching users (this is what fixes the old plants showing up)

    private func userChanged(to uid: String?) {
        currentUID = uid

        // Wipe everything that belonged to the previous user
        plants = []
        history = []
        schedules = [:]
        growth = [:]
        selectedFilter = "All"

        guard uid != nil else { return }   // signed out: stay empty
        loadLocalCareData()
        loadPlantsFromCloud()
    }

    // Plants from (Firebase)

    func loadPlantsFromCloud() {
        let requestedUID = currentUID
        FirebaseService.shared.fetchPlants { fetchedPlants in
            DispatchQueue.main.async {
                // Ignore late answers that belong to a user who already signed out
                guard requestedUID == self.currentUID else { return }
                self.plants = fetchedPlants
                self.ensureSchedules()
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

    func logActivity(action: String, plantName: String, icon: String, color: Color) {
        let newItem = CareHistoryItem(date: Date().formatted(date: .abbreviated, time: .shortened),
                                      action: action, plantName: plantName, icon: icon, color: color)
        history.insert(newItem, at: 0)
    }

    //Garden health (worked out from watering / fertilizer dates)

    // New plant        -Healthy (its schedule starts today)
    // Water due today   Need care
    // Fertilizer late  Need care
    // Water 3+ days late At risk
    func status(for plant: Plant) -> GardenStatus {
        let water = daysUntilDue(.watering, for: plant)
        let feed = daysUntilDue(.fertilizer, for: plant)
        if water <= -3 { return .atRisk }
        if water <= 0 || feed < 0 { return .needsCare }
        return .healthy
    }

    var healthyCount: Int { plants.filter { status(for: $0) == .healthy }.count }
    var needsCareCount: Int { plants.filter { status(for: $0) == .needsCare }.count }
    var atRiskCount: Int { plants.filter { status(for: $0) == .atRisk }.count }
    var allCount: Int { plants.count }

    // 0...100 healthy plants count fully, "need care" plants count half
    var gardenScore: Int {
        guard !plants.isEmpty else { return 0 }
        let points = Double(healthyCount) + Double(needsCareCount) * 0.5
        return Int((points / Double(plants.count) * 100).rounded())
    }

    var gardenTitle: String {
        if plants.isEmpty { return "Start your garden" }
        if gardenScore >= 80 { return "Your garden is thriving" }
        if gardenScore >= 50 { return "Your garden needs a little care" }
        return "Your garden needs attention"
    }

    var gardenSubtitle: String {
        if plants.isEmpty { return "Add your first plant to see its health here." }
        if atRiskCount > 0 { return "\(atRiskCount) \(atRiskCount == 1 ? "plant is" : "plants are") overdue for water." }
        if needsCareCount > 0 { return "\(needsCareCount) \(needsCareCount == 1 ? "plant needs" : "plants need") care today." }
        return "Everything is up to date."
    }

    var filteredPlants: [Plant] {
        switch selectedFilter {
        case "Healthy": return plants.filter { status(for: $0) == .healthy }
        case "Need care": return plants.filter { status(for: $0) == .needsCare }
        case "At risk": return plants.filter { status(for: $0) == .atRisk }
        default: return plants
        }
    }

    // Watering / fertilizer

    func interval(_ kind: CareKind, for plant: Plant) -> Int {
        let s = schedules[plant.name] ?? CareSchedule()
        return kind == .watering ? s.waterEveryDays : s.fertilizeEveryDays
    }

    func nextDate(_ kind: CareKind, for plant: Plant) -> Date {
        let s = schedules[plant.name] ?? CareSchedule()
        let last = kind == .watering ? s.lastWatered : s.lastFertilized
        return Calendar.current.date(byAdding: .day, value: interval(kind, for: plant), to: last) ?? last
    }

    // Negative = overdue, 0 = today
    func daysUntilDue(_ kind: CareKind, for plant: Plant) -> Int {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let due = cal.startOfDay(for: nextDate(kind, for: plant))
        return cal.dateComponents([.day], from: today, to: due).day ?? 0
    }

    func setInterval(_ days: Int, _ kind: CareKind, for plant: Plant) {
        let clamped = min(max(days, kind.intervalRange.lowerBound), kind.intervalRange.upperBound)
        var s = schedules[plant.name] ?? CareSchedule()
        if kind == .watering { s.waterEveryDays = clamped } else { s.fertilizeEveryDays = clamped }
        schedules[plant.name] = s
        saveSchedules()
    }

    func markDone(_ kind: CareKind, for plant: Plant) {
        var s = schedules[plant.name] ?? CareSchedule()
        if kind == .watering { s.lastWatered = Date() } else { s.lastFertilized = Date() }
        schedules[plant.name] = s
        saveSchedules()
        logActivity(action: kind.historyAction, plantName: plant.name, icon: kind.icon, color: kind.tint)
    }

    // Soonest (or most overdue) first
    func plantsSorted(by kind: CareKind) -> [Plant] {
        plants.sorted { daysUntilDue(kind, for: $0) < daysUntilDue(kind, for: $1) }
    }

    func dueCount(_ kind: CareKind) -> Int {
        plants.filter { daysUntilDue(kind, for: $0) <= 0 }.count
    }

    // Growth records

    func growthEntries(for plant: Plant) -> [GrowthEntry] {
        (growth[plant.name] ?? []).sorted { $0.date < $1.date }
    }

    func addGrowth(height: Double, leaves: Int, for plant: Plant) {
        var list = growth[plant.name] ?? []
        list.append(GrowthEntry(date: Date(), height: height, leaves: leaves))
        growth[plant.name] = list
        saveGrowth()
        logActivity(action: "Measured growth", plantName: plant.name, icon: "chart.line.uptrend.xyaxis", color: .green)
    }

    func deleteGrowth(_ entry: GrowthEntry, for plant: Plant) {
        growth[plant.name]?.removeAll { $0.id == entry.id }
        saveGrowth()
    }

    // Saving

    private func ensureSchedules() {
        var changed = false
        for plant in plants where schedules[plant.name] == nil {
            schedules[plant.name] = CareSchedule()
            changed = true
        }
        if changed { saveSchedules() }
    }

    private func saveSchedules() {
        if let data = try? JSONEncoder().encode(schedules) {
            UserDefaults.standard.set(data, forKey: schedulesKey)
        }
    }

    private func saveGrowth() {
        if let data = try? JSONEncoder().encode(growth) {
            UserDefaults.standard.set(data, forKey: growthKey)
        }
    }

    private func loadLocalCareData() {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: schedulesKey),
           let decoded = try? JSONDecoder().decode([String: CareSchedule].self, from: data) {
            schedules = decoded
        }
        if let data = defaults.data(forKey: growthKey),
           let decoded = try? JSONDecoder().decode([String: [GrowthEntry]].self, from: data) {
            growth = decoded
        }
    }
}

struct CareHistoryItem: Identifiable {
    let id = UUID()
    let date: String
    let action: String
    let plantName: String
    let icon: String
    let color: Color
}