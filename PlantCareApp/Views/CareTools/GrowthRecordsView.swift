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
    
    let growthData: [GrowthData] = [
        .init(month: "Jun", value: 20), .init(month: "Jul", value: 23),
        .init(month: "Aug", value: 27), .init(month: "Sep", value: 31)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.plantBackground.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        //Top Card
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "leaf.fill").foregroundColor(.plantPrimary)
                                Text("Monstera Deliciosa").font(.headline)
                                Spacer()
                            }
                            HStack {
                                VStack(alignment: .leading) { Text("31 cm").font(.title2).fontWeight(.bold); Text("Current").font(.caption).foregroundColor(.gray) }
                                Spacer()
                                VStack(alignment: .leading) { Text("+ 4 cm").font(.title2).fontWeight(.bold).foregroundColor(.plantPrimary); Text("Growth").font(.caption).foregroundColor(.gray) }
                                Spacer()
                                VStack(alignment: .leading) { Text("8").font(.title2).fontWeight(.bold); Text("Leaves").font(.caption).foregroundColor(.gray) }
                            }
                        }.padding(20).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        // Chart Section
                        VStack(spacing: 20) {
                            // Segment Control
                            HStack {
                                Button(action: { selectedTab = "Height" }) {
                                    Text("Height").font(.subheadline).fontWeight(.semibold).foregroundColor(selectedTab == "Height" ? .white : .plantText)
                                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                                        .background(selectedTab == "Height" ? Color.plantPrimary : Color.clear).clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                Button(action: { selectedTab = "Leaves" }) {
                                    Text("Leaves").font(.subheadline).fontWeight(.semibold).foregroundColor(selectedTab == "Leaves" ? .white : .plantText)
                                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                                        .background(selectedTab == "Leaves" ? Color.plantPrimary : Color.clear).clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }.padding(4).background(Color.plantBackground).clipShape(RoundedRectangle(cornerRadius: 14))
                            
                            Chart(growthData) { item in
                                LineMark(x: .value("Month", item.month), y: .value("Height", item.value))
                                    .foregroundStyle(Color.plantPrimary).lineStyle(StrokeStyle(lineWidth: 3)).symbol(Circle())
                                PointMark(x: .value("Month", item.month), y: .value("Height", item.value))
                                    .annotation(position: .top) {
                                        Text("\(Int(item.value)) cm") // <-- Fixed the decimal issue
                                            .font(.caption2).foregroundColor(.gray)
                                    }.foregroundStyle(Color.plantPrimary)
                            }.frame(height: 200).padding(.top, 20)
                        }.padding(20).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 20))
                    }.padding(20)
                }
            }
            .navigationTitle("Growth Records").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarLeading) { Button(action: { dismiss() }) { Image(systemName: "chevron.left").foregroundColor(.plantText) } } }
        }
    }
}
struct GrowthData: Identifiable { let id = UUID(); let month: String; let value: Double }