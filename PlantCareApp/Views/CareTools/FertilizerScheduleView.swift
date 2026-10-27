import SwiftUI

struct FertilizerScheduleView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = MyPlantsViewModel.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.plantBackground.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        if let firstPlant = viewModel.plants.first {
                            Text("NEXT FERTILIZING").font(.caption).fontWeight(.bold).foregroundColor(.gray)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "leaf.fill").foregroundColor(.orange).padding(10).background(Color.orange.opacity(0.2)).clipShape(Circle())
                                    VStack(alignment: .leading) {
                                        Text(firstPlant.name).font(.headline)
                                        Text("Due in 3 days").font(.caption).foregroundColor(.orange)
                                    }
                                }
                                Text("Liquid fertilizer • Every 2 weeks").font(.subheadline).foregroundColor(.gray)
                                
                                Button(action: {
                                    viewModel.logActivity(action: "Fertilized", plantName: firstPlant.name, icon: "sparkles", color: .orange)
                                    NotificationService.shared.scheduleNotification(title: "Fertilizer Applied!", body: "You fertilized \(firstPlant.name).")
                                }) {
                                    Text("Mark as Applied")
                                        .font(.headline).foregroundColor(.white)
                                        .frame(maxWidth: .infinity).padding()
                                        .background(Color.plantPrimary).cornerRadius(12)
                                }
                            }
                            .padding().background(Color.white).clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Fertilizer Schedule").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) { Image(systemName: "chevron.left") }
                }
            }
        }
    }
}