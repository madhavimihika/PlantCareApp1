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
                        if let uiImage = loadImageFromDisk(name: plant.name) {
                            Image(uiImage: uiImage).resizable().scaledToFill().frame(height: 200).clipShape(RoundedRectangle(cornerRadius: 20))
                        } else {
                            Image(systemName: "leaf.fill").resizable().scaledToFit().frame(height: 80)
                                .foregroundColor(.plantPrimary).frame(height: 200).frame(maxWidth: .infinity)
                                .background(Color.plantBackground).clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(plant.name).font(.largeTitle).fontWeight(.bold).foregroundColor(.plantText)
                            Text(plant.botanicalName).font(.subheadline).foregroundColor(.gray).italic()
                            
                            Divider()
                            
                            HStack {
                                Image(systemName: "mappin.circle.fill").foregroundColor(.plantPrimary)
                                Text(plant.location).foregroundColor(.plantText)
                            }.font(.subheadline)
                            
                            HStack {
                                Image(systemName: "heart.fill").foregroundColor(.plantPrimary)
                                Text(plant.health.rawValue).foregroundColor(.plantText)
                            }.font(.subheadline)
                        }
                        .padding().frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white).clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        NavigationLink(destination: WateringScheduleView(plant: plant)) {
                            Text("Set Watering Schedule")
                                .font(.headline).foregroundColor(.white).frame(maxWidth: .infinity).padding()
                                .background(Color.plantPrimary).cornerRadius(15)
                        }
                    }.padding(20)
                }
            }
            .navigationTitle("Plant Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left").foregroundColor(.plantText)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    func loadImageFromDisk(name: String) -> UIImage? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filePath = paths[0].appendingPathComponent("\(name).png")
        return UIImage(contentsOfFile: filePath.path)
    }
}