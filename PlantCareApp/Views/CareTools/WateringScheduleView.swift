import SwiftUI

struct WateringScheduleView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = MyPlantsViewModel.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.plantBackground.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        if let firstPlant = viewModel.plants.first {
                            VStack(alignment: .leading, spacing: 0) {
                                // Top Image Area
                                ZStack(alignment: .bottomLeading) {
                                    Color.green.opacity(0.15).frame(height: 160)
                                        .overlay(Image(systemName: "leaf.fill").font(.system(size: 60)).foregroundColor(.white.opacity(0.8)))
                                    
                                    HStack {
                                        Image(systemName: "drop.fill")
                                        Text("Every 5 days")
                                    }.font(.caption).fontWeight(.bold).foregroundColor(.white)
                                    .padding(.horizontal, 12).padding(.vertical, 6)
                                    .background(Color.plantPrimary).clipShape(Capsule()).padding(16)
                                }
                                
                                // Details Area
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("TOMORROW").font(.caption).fontWeight(.bold).foregroundColor(.gray)
                                    Text(firstPlant.name).font(.title2).fontWeight(.bold).foregroundColor(.plantText) // <-- Name shows here
                                    
                                    HStack {
                                        Image(systemName: "clock.fill").foregroundColor(.plantPrimary)
                                        Text("8:00 AM").font(.headline).foregroundColor(.plantText)
                                    }
                                    Text("Location: \(firstPlant.location)").font(.caption).foregroundColor(.gray)
                                    
                                    Button(action: {}) {
                                        Text("Mark as Watered")
                                            .font(.headline).foregroundColor(.white).frame(maxWidth: .infinity)
                                            .padding().background(Color.plantPrimary).clipShape(RoundedRectangle(cornerRadius: 16))
                                    }.padding(.top, 8)
                                }.padding(20)
                            }
                            .background(Color.white).clipShape(RoundedRectangle(cornerRadius: 24))
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                        } else {
                            Text("No plants added yet. Please add a plant first.").padding()
                        }
                        
                        // Upcoming List
                        Text("Upcoming").font(.title3).fontWeight(.bold).foregroundColor(.plantText).padding(.top, 10)
                        
                        VStack(spacing: 12) {
                            ForEach(viewModel.plants) { plant in
                                HStack {
                                    Image(systemName: "leaf.fill").foregroundColor(.plantPrimary)
                                        .frame(width: 50, height: 50).background(Color.plantBackground).clipShape(RoundedRectangle(cornerRadius: 12))
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(plant.name).font(.headline)
                                        Text("Tomorrow • 8:00 AM").font(.caption).foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Circle().fill(Color.gray.opacity(0.3)).frame(width: 8, height: 8)
                                }.padding(16).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                        }
                    }.padding(20)
                }
            }
            .navigationTitle("Watering Schedule").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarLeading) { Button(action: { dismiss() }) { Image(systemName: "chevron.left").foregroundColor(.plantText) } } }
        }
    }
}