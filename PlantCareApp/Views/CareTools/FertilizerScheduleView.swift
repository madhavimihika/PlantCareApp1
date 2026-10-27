import SwiftUI

struct FertilizerScheduleView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = MyPlantsViewModel.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.plantBackground.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Next Fert Card
                        if let firstPlant = viewModel.plants.first {
                            VStack(alignment: .leading, spacing: 0) {
                                // Top image Area
                                ZStack(alignment: .bottomLeading) {
                                    Color.orange.opacity(0.1)
                                        .frame(height: 160)
                                        .overlay(Image(systemName: "leaf.fill").font(.system(size: 60)).foregroundColor(.orange.opacity(0.5)))
                                    
                                    HStack {
                                        Image(systemName: "sparkles")
                                        Text("Every 2 weeks")
                                    }
                                    .font(.caption).fontWeight(.bold).foregroundColor(.white)
                                    .padding(.horizontal, 12).padding(.vertical, 6)
                                    .background(Color.orange)
                                    .clipShape(Capsule())
                                    .padding(16)
                                }
                                
                                // Details Area
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("NEXT FERTILIZING").font(.caption).fontWeight(.bold).foregroundColor(.gray)
                                    
                                    Text(firstPlant.name)
                                        .font(.title2).fontWeight(.bold).foregroundColor(.plantText)
                                    
                                    HStack {
                                        Image(systemName: "drop.fill").foregroundColor(.orange)
                                        Text("Liquid fertilizer").font(.headline).foregroundColor(.plantText)
                                    }
                                    
                                    Text("Due in 3 days • Location: \(firstPlant.location)")
                                        .font(.caption).foregroundColor(.gray)
                                    
                                    Button(action: {}) {
                                        Text("Mark as Applied")
                                            .font(.headline).foregroundColor(.white).frame(maxWidth: .infinity)
                                            .padding().background(Color.plantPrimary).clipShape(RoundedRectangle(cornerRadius: 16))
                                    }
                                    .padding(.top, 8)
                                }
                                .padding(20)
                            }
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                            
                        } else {
                            Text("No plants added yet. Go to My Plants to add one.")
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                        
                        // Upcoming Section
                        Text("Upcoming")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.plantText)
                            .padding(.top, 10)
                        
                        // Upcoming List
                        VStack(spacing: 12) {
                            ForEach(viewModel.plants) { plant in
                                HStack {
                                    Image(systemName: "leaf.fill")
                                        .foregroundColor(.orange)
                                        .frame(width: 50, height: 50)
                                        .background(Color.orange.opacity(0.15))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(plant.name).font(.headline)
                                        Text("In 3 days • Liquid").font(.caption).foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: "checkmark.circle").foregroundColor(.gray.opacity(0.3))
                                }
                                .padding(16)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Fertilizer Schedule")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left").foregroundColor(.plantText)
                    }
                }
            }
        }
    }
}