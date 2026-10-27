import SwiftUI

struct PlantDetailView: View {
    var plant: Plant
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.plantBackground.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        // Image
                        Color.gray.opacity(0.2).frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(Image(systemName: "leaf.fill").font(.system(size: 60)).foregroundColor(.plantPrimary))
                        
                        // Details Card
                        VStack(alignment: .leading, spacing: 10) {
                            Text(plant.name).font(.largeTitle).fontWeight(.bold)
                            Text(plant.botanicalName).font(.subheadline).foregroundColor(.gray).italic()
                            
                            Divider()
                            
                            HStack {
                                Image(systemName: "mappin.circle.fill").foregroundColor(.plantPrimary)
                                Text(plant.location)
                            }.font(.subheadline)
                            
                            HStack {
                                Image(systemName: "heart.fill").foregroundColor(plant.health == .healthy ? .green : .orange)
                                Text(plant.health.rawValue)
                            }.font(.subheadline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        // Action Button to Care Tools
                        NavigationLink(destination: WateringScheduleView()) {
                            Text("Set Watering Schedule")
                                .font(.headline).foregroundColor(.white)
                                .frame(maxWidth: .infinity).padding()
                                .background(Color.plantPrimary).cornerRadius(15)
                        }
                        
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Plant Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}