import SwiftUI

struct FertilizerScheduleView: View {
    var plant: Plant? = nil
    var body: some View {
        CareScheduleView(kind: .fertilizer, plant: plant)
    }
}