//
//  GrowthRecordsView.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//
import SwiftUI
import Charts 

struct GrowthRecordsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedTab = "Height"
    
    // Data for the chart
    let growthData: [GrowthData] = [
        .init(month: "Jun", value: 20),
        .init(month: "Jul", value: 23),
        .init(month: "Aug", value: 27),
        .init(month: "Sep", value: 31)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.plantBackground.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // Top Card
                        VStack(spacing: 15) {
                            HStack {
                                Image(systemName: "leaf.fill").foregroundColor(.plantSecondary)
                                Text("Monstera Deliciosa").font(.headline)
                                Spacer()
                                Image(systemName: "chevron.down").font(.caption).foregroundColor(.gray)
                            }
                            
                            HStack {
                                VStack(alignment: .leading) { Text("31 cm").font(.title2).fontWeight(.bold); Text("Current").font(.caption).foregroundColor(.gray) }
                                Spacer()
                                VStack(alignment: .leading) { Text("+ 4 cm").font(.title2).fontWeight(.bold).foregroundColor(.plantPrimary); Text("Since 27 cm").font(.caption).foregroundColor(.gray) }
                                Spacer()
                                VStack(alignment: .leading) { Text("8").font(.title2).fontWeight(.bold); Text("Leaves").font(.caption).foregroundColor(.gray) }
                            }
                        }
                        .padding(20).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        // Chart Section
                        VStack(spacing: 15) {
                            // Custom Segmented Control
                            HStack {
                                Button(action: { selectedTab = "Height" }) {
                                    Text("Height").font(.subheadline).fontWeight(.semibold).foregroundColor(selectedTab == "Height" ? .white : .plantText)
                                        .frame(maxWidth: .infinity).padding(.vertical, 8)
                                        .background(selectedTab == "Height" ? Color.plantPrimary : Color.clear)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                Button(action: { selectedTab = "Leaves" }) {
                                    Text("Leaves").font(.subheadline).fontWeight(.semibold).foregroundColor(selectedTab == "Leaves" ? .white : .plantText)
                                        .frame(maxWidth: .infinity).padding(.vertical, 8)
                                        .background(selectedTab == "Leaves" ? Color.plantPrimary : Color.clear)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                            .padding(4).background(Color.plantBackground).clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            // Swift Chart
                            Chart(growthData) { item in
                                LineMark(
                                    x: .value("Month", item.month),
                                    y: .value("Height", item.value)
                                )
                                .foregroundStyle(Color.plantPrimary)
                                .lineStyle(StrokeStyle(lineWidth: 3))
                                .symbol(Circle())
                                
                                PointMark(
                                    x: .value("Month", item.month),
                                    y: .value("Height", item.value)
                                )
                                .annotation(position: .top) {
                                    Text("\(item.value) cm").font(.caption2).foregroundColor(.gray)
                                }
                                .foregroundStyle(Color.plantPrimary)
                            }
                            .frame(height: 200)
                            .padding(.top, 20)
                        }
                        .padding(20).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        // Measurement History
                        VStack(alignment: .leading, spacing: 12) {
                            Text("MEASUREMENT HISTORY").font(.caption).fontWeight(.bold).foregroundColor(.gray)
                            HistoryRow(date: "Sep 10", desc: "8 leaves • New leaf unfurling", value: "31 cm")
                            HistoryRow(date: "Aug 12", desc: "7 leaves • Repotted", value: "27 cm")
                            HistoryRow(date: "Jul 9", desc: "5 leaves", value: "23 cm")
                        }
                        
                        Button(action: {}) {
                            Text("+ Add Measurement").font(.headline).foregroundColor(.plantPrimary)
                                .frame(maxWidth: .infinity).padding().background(Color.white).cornerRadius(15)
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Growth Records")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left").foregroundColor(.plantText)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "plus").foregroundColor(.white).padding(8).background(Color.plantPrimary).clipShape(Circle())
                    }
                }
            }
        }
    }
}

struct GrowthData: Identifiable {
    let id = UUID()
    let month: String
    let value: Double
}

struct HistoryRow: View {
    var date: String; var desc: String; var value: String
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(date).font(.subheadline).fontWeight(.bold)
                Text(desc).font(.caption).foregroundColor(.gray)
            }
            Spacer()
            Text(value).font(.subheadline).fontWeight(.bold).foregroundColor(.plantPrimary)
                .padding(.horizontal, 10).padding(.vertical, 4).background(Color.plantBackground).clipShape(Capsule())
        }
        .padding(15).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

