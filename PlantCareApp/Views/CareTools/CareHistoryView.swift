import SwiftUI

struct CareHistoryView: View {
    @Environment(\.dismiss) var dismiss
    
    // Fake data for the history timeline
    let historyItems = [
        CareHistoryItem(date: "Today, 8:30 AM", action: "Watered", plantName: "Monstera Deliciosa", icon: "drop.fill", color: .blue),
        CareHistoryItem(date: "Sep 22, 5:10 PM", action: "Growth Photo Added", plantName: "Monstera Deliciosa", icon: "camera.fill", color: .green),
        CareHistoryItem(date: "Sep 20, 9:00 AM", action: "Fertilizer Applied", plantName: "Monstera Deliciosa", icon: "leaf.fill", color: .orange),
        CareHistoryItem(date: "Sep 15, 11:40 AM", action: "Health Scan", plantName: "Monstera Deliciosa", icon: "magnifyingglass", color: .purple),
        CareHistoryItem(date: "Sep 10, 7:15 PM", action: "Growth Recorded", plantName: "Monstera Deliciosa", icon: "chart.line.uptrend.xyaxis", color: .pink)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.plantBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Top Header
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("MY PLANT CARE").font(.caption).fontWeight(.bold).foregroundColor(.gray)
                                Text("Care History").font(.system(size: 34, weight: .bold, design: .serif)).foregroundColor(.plantText)
                            }
                            Spacer()
                        }
                        
                        Text("3 scans in the last 30 days").font(.subheadline).foregroundColor(.gray)
                        
                        // Timeline List
                        VStack(spacing: 15) {
                            ForEach(historyItems) { item in
                                HStack(alignment: .top, spacing: 15) {
                                    
                                    // Icon Circle
                                    Image(systemName: item.icon)
                                        .font(.title3)
                                        .foregroundColor(item.color)
                                        .frame(width: 40, height: 40)
                                        .background(item.color.opacity(0.15))
                                        .clipShape(Circle())
                                    
                                    // Details
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.action).font(.headline).foregroundColor(.plantText)
                                        Text(item.plantName).font(.subheadline).foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    // Date
                                    Text(item.date)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct CareHistoryItem: Identifiable {
    let id = UUID()
    let date: String
    let action: String
    let plantName: String
    let icon: String
    let color: Color
}
