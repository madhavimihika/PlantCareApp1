import SwiftUI

struct WateringScheduleView: View {
    var plant: Plant? = nil
    var body: some View {
        CareScheduleView(kind: .watering, plant: plant)
    }
}