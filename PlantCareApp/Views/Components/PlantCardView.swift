import SwiftUI

struct PlantCardView: View {
    let plant: Plant
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Fixed height image area
            Image(systemName: "leaf.fill")
                .resizable().scaledToFit().frame(width: 40, height: 40)
                .foregroundColor(.plantPrimary)
                .frame(maxWidth: .infinity).frame(height: 100) // <-- Fixed height
                .background(Color.plantBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(plant.name).font(.headline).foregroundColor(.plantText).lineLimit(1)
                Text(plant.location).font(.caption).foregroundColor(.gray).lineLimit(1)
            }
            
            Text(plant.health.rawValue)
                .font(.caption2).fontWeight(.bold)
                .foregroundColor(plant.health == .healthy ? .plantPrimary : .orange)
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(plant.health == .healthy ? Color.plantBackground : Color.orange.opacity(0.1))
                .clipShape(Capsule())
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}