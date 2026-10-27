import SwiftUI

struct WateringScheduleView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = MyPlantsViewModel.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.plantBackground.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        //next watering card
                        if let firstPlant = viewModel.plants.first {
                            VStack(alignment: .leading, spacing: 0) {
                                ZStack(alignment: .bottomLeading) {
                                    Color.green.opacity(0.2)
                                        .frame(height: 180)
                                        .overlay(Image(systemName: "leaf.fill").font(.system(size: 80)).foregroundColor(.white.opacity(0.5)))
                                    
                                    HStack {
                                        Image(systemName: "drop.fill")
                                        Text("Every 5 days")
                                    }
                                    .font(.caption).fontWeight(.bold).foregroundColor(.white)
                                    .padding(.horizontal, 10).padding(.vertical, 6)
                                    .background(Color.plantPrimary).clipShape(Capsule()).padding(15)
                                }
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("TOMORROW").font(.caption).fontWeight(.bold).foregroundColor(.gray)
                                    Text(firstPlant.name).font(.title2).fontWeight(.bold)
                                    
                                    HStack {
                                        Image(systemName: "clock.fill")
                                        Text("8:00 AM").font(.headline)
                                    }
                                    Text("Location: \(firstPlant.location)").font(.caption).foregroundColor(.gray)
                                    
                                    Button(action: {
                                        viewModel.logActivity(action: "Watered", plantName: firstPlant.name, icon: "drop.fill", color: .blue)
                                        NotificationService.shared.scheduleNotification(title: "Watering Done!", body: "You watered \(firstPlant.name).")
                                    }) {
                                        HStack {
                                            Image(systemName: "checkmark")
                                            Text("Mark as Watered")
                                        }
                                        .font(.headline).foregroundColor(.white).frame(maxWidth: .infinity)
                                        .padding().background(Color.plantPrimary).cornerRadius(12)
                                    }
                                    .padding(.top, 10)
                                }
                                .padding(20)
                            }
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                        } else {
                            Text("No plants added yet.").padding()
                        }
                        
                        HStack {
                            Text("Upcoming").font(.title3).fontWeight(.bold)
                            Spacer()
                            Text("View calendar").font(.subheadline).foregroundColor(.plantPrimary)
                        }
                        
                        VStack(spacing: 12) {
                            ForEach(viewModel.plants) { plant in
                                HStack {
                                    Color.plantSecondary.opacity(0.3).frame(width: 60, height: 60).clipShape(RoundedRectangle(cornerRadius: 12))
                                        .overlay(Image(systemName: "leaf.fill").foregroundColor(.plantPrimary))
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(plant.name).font(.headline)
                                        Text("Tomorrow • 8:00 AM").font(.caption).foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Circle().fill(Color.gray.opacity(0.3)).frame(width: 8, height: 8)
                                }
                                .padding(12).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Watering Schedule").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) { Image(systemName: "chevron.left").foregroundColor(.plantText) }
                }
            }
        }
    }
}