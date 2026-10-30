import SwiftUI

struct CareToolsView: View {
    let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.plantBackground.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("MY PLANT CARE").font(.caption).fontWeight(.bold).foregroundColor(.gray).tracking(1)
                                Text("Care tools").font(.system(size: 34, weight: .bold, design: .serif)).foregroundColor(.plantText)
                            }
                            Spacer()
                            Text("M").font(.headline).foregroundColor(.white).frame(width: 40, height: 40).background(Color.orange.opacity(0.7)).clipShape(Circle())
                        }.padding(.top, 10)
                        
                        ZStack(alignment: .bottomLeading) {
                            Color.plantSecondary.frame(height: 200).frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay(LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.6)]), startPoint: .center, endPoint: .bottom).clipShape(RoundedRectangle(cornerRadius: 20)))
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("3 plants need\nyour attention").font(.title).fontWeight(.bold).foregroundColor(.white)
                                Button(action: {}) {
                                    Text("View care plan").font(.footnote).fontWeight(.bold).foregroundColor(.plantPrimary).padding(.horizontal, 16).padding(.vertical, 8).background(Color.white).clipShape(Capsule())
                                }
                            }.padding(20)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Organize your garden").font(.title2).fontWeight(.bold).foregroundColor(.plantText)
                            Text("Everything your plants need, in one place.").font(.subheadline).foregroundColor(.gray)
                        }
                        
                        CareToolsGrid {
                            NavigationLink(destination: CareHistoryView()) {
                                ToolCard(icon: "clock.arrow.circlepath", iconColor: .purple, title: "Care history", subtitle: "All activity in one place")
                            }.buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: ReminderSettingsView()) {
                                ToolCard(icon: "camera.viewfinder", iconColor: .green, title: "Remind & Scan", subtitle: "Smart alerts")
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20).padding(.bottom, 30)
                }
            }.navigationBarHidden(true)
        }
    }
}

// This handles the dynamic Watering, Fertilizer and Growth cards
struct CareToolsGrid<Extra: View>: View {
    @ObservedObject private var viewModel = MyPlantsViewModel.shared
    private let extra: Extra
    private let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]

    init(@ViewBuilder extra: () -> Extra) {
        self.extra = extra()
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            NavigationLink(destination: WateringScheduleView()) {
                ToolCard(icon: "drop.fill", iconColor: .blue, title: "Watering", subtitle: subtitle(.watering), badge: viewModel.dueCount(.watering))
            }.buttonStyle(.plain)

            NavigationLink(destination: FertilizerScheduleView()) {
                ToolCard(icon: "sparkles", iconColor: .orange, title: "Fertilizer", subtitle: subtitle(.fertilizer), badge: viewModel.dueCount(.fertilizer))
            }.buttonStyle(.plain)

            NavigationLink(destination: GrowthRecordsView()) {
                ToolCard(icon: "chart.line.uptrend.xyaxis", iconColor: .plantPrimary, title: "Growth", subtitle: viewModel.plants.isEmpty ? "No plants yet" : "Track height and leaves")
            }.buttonStyle(.plain)

            extra
        }
    }

    private func subtitle(_ kind: CareKind) -> String {
        if viewModel.plants.isEmpty { return "No plants yet" }
        let due = viewModel.dueCount(kind)
        if due == 0 { return "All caught up" }
        return "\(due) \(due == 1 ? "plant" : "plants") \(due == 1 ? "needs" : "need") \(kind == .watering ? "water" : "feeding")"
    }
}