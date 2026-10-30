import SwiftUI

enum CareKind: String, CaseIterable {
    case watering
    case fertilizer

    var title: String { self == .watering ? "Watering" : "Fertilizer" }
    var icon: String { self == .watering ? "drop.fill" : "sparkles" }
    var tint: Color { self == .watering ? .blue : .orange }
    var nextLabel: String { self == .watering ? "NEXT WATERING" : "NEXT FEEDING" }
    var doneButton: String { self == .watering ? "Mark as watered" : "Mark as fertilized" }
    var historyAction: String { self == .watering ? "Watered" : "Fertilized" }
    var needsText: String { self == .watering ? "need water" : "need feeding" }

    var intervalRange: ClosedRange<Int> { self == .watering ? 1...30 : 7...90 }
    var intervalStep: Int { self == .watering ? 1 : 7 }

    func intervalText(_ days: Int) -> String {
        if days % 7 == 0 {
            let weeks = days / 7
            return weeks == 1 ? "Every week" : "Every \(weeks) weeks"
        }
        return days == 1 ? "Every day" : "Every \(days) days"
    }

    func statusText(days: Int) -> String {
        if days < 0 { return days == -1 ? "Overdue by 1 day" : "Overdue by \(-days) days" }
        if days == 0 { return "Due today" }
        if days == 1 { return "Tomorrow" }
        return "In \(days) days"
    }

    func shortStatus(days: Int) -> String {
        if days < 0 { return "Overdue" }
        if days == 0 { return "Today" }
        if days == 1 { return "Tomorrow" }
        return "\(days)d"
    }

    func statusColor(days: Int) -> Color {
        if days < 0 { return .red }
        if days == 0 { return tint }
        return .secondary
    }
}

struct CareSchedule: Codable {
    var waterEveryDays: Int = 5
    var fertilizeEveryDays: Int = 14
    var lastWatered: Date = Date()
    var lastFertilized: Date = Date()
}

struct GrowthEntry: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var height: Double
    var leaves: Int
}