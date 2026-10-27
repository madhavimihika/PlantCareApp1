import SwiftUI

struct CareToolsView: View {
    @StateObject private var viewModel = MyPlantsViewModel.shared
    let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.plantBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Header
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("MY PLANT CARE").font(.caption).fontWeight(.bold).foregroundColor(.gray).tracking(1)
                                Text("Care tools").font(.system(size: 34, weight: .bold, design: .serif)).foregroundColor(.plantText)
                            }
                            Spacer()
                            Text("M").font(.headline).foregroundColor(.white).frame(width: 40, height: 40).background(Color.orange.opacity(0.7)).clipShape(Circle())
                        }
                        .padding(.top, 10)
                        
                        // Hero Banner
                        ZStack(alignment: .bottomLeading) {
                            Color.plantSecondary.frame(height: 200).frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay(
                                    LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.6)]), startPoint: .center, endPoint: .bottom)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                )
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("3 plants need\nyour attention").font(.title).fontWeight(.bold).foregroundColor(.white)
                                Button(action: {}) {
                                    Text("View care plan").font(.footnote).fontWeight(.bold).foregroundColor(.plantPrimary)
                                        .padding(.horizontal, 16).padding(.vertical, 8).background(Color.white).clipShape(Capsule())
                                }
                            }.padding(20)
                        }
                        
                        // Section Title
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Organize your garden").font(.title2).fontWeight(.bold).foregroundColor(.plantText)
                            Text("Everything your plants need, in one place.").font(.subheadline).foregroundColor(.gray)
                        }
                        
                        // Grid of Tools
                        LazyVGrid(columns: columns, spacing: 16) {
                            // chamged Pass the first plant (or a dummy plant if none exist)
                            NavigationLink(destination: WateringScheduleView(plant: viewModel.plants.first ?? Plant(name: "Unknown", botanicalName: "", location: "", health: .healthy, imageName: ""))) {
                                ToolCard(icon: "drop.fill", iconColor: .blue, title: "Watering", subtitle: "4 plants due this week")
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            ToolCard(icon: "sparkles", iconColor: .orange, title: "Fertilizer", subtitle: "Next feed in 2 days")
                            
                            NavigationLink(destination: GrowthRecordsView()) {
                                ToolCard(icon: "chart.line.uptrend.xyaxis", iconColor: .green, title: "Growth records", subtitle: "+8.4 cm this month")
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            ToolCard(icon: "photo", iconColor: .pink, title: "Plant photos", subtitle: "48 memories")
                            
                            NavigationLink(destination: CareHistoryView()) {
                                ToolCard(icon: "clock.arrow.circlepath", iconColor: .purple, title: "Care history", subtitle: "All activity in one place")
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: ReminderSettingsView()) {
                                ToolCard(icon: "camera.viewfinder", iconColor: .green, title: "Remind & Scan", subtitle: "Smart alerts")
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// Reusable
struct ToolCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(iconColor)
                .frame(width: 45, height: 45)
                .background(iconColor.opacity(0.15))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.plantText)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
    }
}