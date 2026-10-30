//
//  GrowthRecordsView.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//
//
//  GrowthRecordsView.swift
//  PlantCareApp
//
import SwiftUI
import Charts

struct GrowthRecordsView: View {
    enum Metric: String, CaseIterable { case height = "Height"; case leaves = "Leaves" }

    @ObservedObject private var viewModel = MyPlantsViewModel.shared
    @State private var selectedName: String?
    @State private var metric: Metric = .height
    @State private var showingAdd = false

    init(plant: Plant? = nil) { _selectedName = State(initialValue: plant?.name) }

    private var plant: Plant? {
        if let name = selectedName, let match = viewModel.plants.first(where: { $0.name == name }) { return match }
        return viewModel.plants.first
    }

    private var entries: [GrowthEntry] {
        guard let plant = plant else { return [] }
        return viewModel.growthEntries(for: plant)
    }

    var body: some View {
        ZStack {
            Color.plantBackground.ignoresSafeArea()
            if let current = plant {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        if viewModel.plants.count > 1 { plantPicker }
                        statsCard(for: current)
                        chartCard
                        if !entries.isEmpty { historySection(for: current) }
                    }.padding(20)
                }
            } else { emptyPlants }
        }
        .navigationTitle("Growth records").navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if plant != nil {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingAdd = true } label: {
                        Image(systemName: "plus.circle.fill").foregroundColor(.plantPrimary)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAdd) {
            if let current = plant {
                AddGrowthSheet(plantName: current.name, height: entries.last?.height ?? 10, leaves: entries.last?.leaves ?? 1) { height, leaves in
                    viewModel.addGrowth(height: height, leaves: leaves, for: current)
                }
            }
        }
    }

    private var plantPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.plants, id: \.name) { item in
                    let isSelected = item.name == plant?.name
                    Button { withAnimation(.easeInOut) { selectedName = item.name } } label: {
                        HStack(spacing: 8) {
                            PlantPhoto(name: item.name, size: 26, corner: 13)
                            Text(item.name).font(.subheadline.weight(.semibold))
                        }
                        .foregroundColor(isSelected ? .black : .plantText)
                        .padding(.leading, 6).padding(.trailing, 14).padding(.vertical, 6)
                        .background(Capsule().fill(isSelected ? Color.plantPrimary : Color.white))
                    }
                }
            }
        }
    }

    private func statsCard(for current: Plant) -> some View {
        let latest = entries.last
        let first = entries.first
        let gained = (latest != nil && first != nil) ? latest!.height - first!.height : 0

        return VStack(spacing: 16) {
            HStack(spacing: 10) {
                PlantPhoto(name: current.name, size: 40, corner: 12)
                VStack(alignment: .leading, spacing: 2) {
                    Text(current.name).font(.system(.headline, design: .rounded)).foregroundColor(.plantText)
                    Text(current.botanicalName).font(.caption).italic().foregroundColor(.gray)
                }
                Spacer()
            }
            HStack {
                stat(value: latest.map { cm($0.height) } ?? "–", label: "Current", color: .plantText)
                Spacer()
                stat(value: entries.count > 1 ? "+ \(cm(gained))" : "–", label: "Growth", color: .plantPrimary)
                Spacer()
                stat(value: latest.map { "\($0.leaves)" } ?? "–", label: "Leaves", color: .plantText)
            }
        }
        .padding(20).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous)).shadow(color: Color.black.opacity(0.05), radius: 10, y: 4)
    }

    private func stat(value: String, label: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value).font(.system(.title3, design: .rounded).weight(.bold)).foregroundColor(color)
            Text(label).font(.caption).foregroundColor(.black)
        }
    }

    private var chartCard: some View {
        VStack(spacing: 18) {
            HStack(spacing: 4) {
                ForEach(Metric.allCases, id: \.self) { item in
                    Button {
                        withAnimation(.easeInOut) { metric = item }
                    } label: {
                        Text(item.rawValue).font(.subheadline.weight(.semibold)).foregroundColor(metric == item ? .white : .plantText)
                            .frame(maxWidth: .infinity).padding(.vertical, 10)
                            .background(RoundedRectangle(cornerRadius: 11, style: .continuous).fill(metric == item ? Color.plantPrimary : Color.clear))
                    }
                }
            }.padding(4).background(Color.plantBackground).clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            if entries.count >= 2 {
                Chart(entries) { item in
                    AreaMark(x: .value("Date", item.date), y: .value(metric.rawValue, value(of: item)))
                        .foregroundStyle(LinearGradient(colors: [Color.plantPrimary.opacity(0.28), Color.plantPrimary.opacity(0.0)], startPoint: .top, endPoint: .bottom))
                        .interpolationMethod(.catmullRom)
                    LineMark(x: .value("Date", item.date), y: .value(metric.rawValue, value(of: item)))
                        .foregroundStyle(Color.plantPrimary).lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round)).interpolationMethod(.catmullRom)
                    PointMark(x: .value("Date", item.date), y: .value(metric.rawValue, value(of: item))).foregroundStyle(Color.plantPrimary)
                }
                .chartYScale(domain: .automatic(includesZero: false))
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 4)) { _ in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                    }
                }
                .frame(height: 200)
            } else {
                VStack(spacing: 10) {
                    Image(systemName: "chart.line.uptrend.xyaxis").font(.system(size: 34)).foregroundColor(.plantPrimary.opacity(0.5))
                    Text(entries.isEmpty ? "No measurements yet" : "Add one more measurement to see the curve").font(.subheadline.weight(.medium)).foregroundColor(.plantText)
                    Button { showingAdd = true } label: {
                        Text("Add measurement").font(.subheadline.weight(.semibold)).foregroundColor(.white)
                            .padding(.horizontal, 18).padding(.vertical, 10).background(Capsule().fill(Color.plantPrimary))
                    }
                }.frame(maxWidth: .infinity).frame(height: 200)
            }
        }.padding(20).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous)).shadow(color: Color.black.opacity(0.05), radius: 10, y: 4)
    }

    private func historySection(for current: Plant) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("History").font(.system(.title3, design: .rounded).weight(.bold)).foregroundColor(.plantText)
            ForEach(Array(entries.enumerated()).reversed(), id: \.element.id) { index, entry in
                HStack(spacing: 12) {
                    Image(systemName: "ruler").foregroundColor(.plantPrimary).frame(width: 42, height: 42).background(Color.plantPrimary.opacity(0.12)).clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    VStack(alignment: .leading, spacing: 3) {
                        Text(entry.date.formatted(date: .abbreviated, time: .omitted)).font(.headline).foregroundColor(.plantText)
                        Text("\(cm(entry.height)) • \(entry.leaves) leaves").font(.caption).foregroundColor(.black)
                    }
                    Spacer()
                    if index > 0 {
                        let diff = entry.height - entries[index - 1].height
                        Text("\(diff >= 0 ? "+" : "-")\(cm(abs(diff)))").font(.caption.weight(.semibold)).foregroundColor(diff >= 0 ? .plantPrimary : .red)
                    }
                    Menu {
                        Button(role: .destructive) { viewModel.deleteGrowth(entry, for: current) } label: { Label("Delete", systemImage: "trash") }
                    } label: {
                        Image(systemName: "ellipsis").foregroundColor(.black).frame(width: 30, height: 30)
                    }
                }.padding(14).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
        }
    }

    private var emptyPlants: some View {
        VStack(spacing: 12) {
            Image(systemName: "leaf.fill").font(.system(size: 44)).foregroundColor(.plantPrimary.opacity(0.6))
            Text("No plants yet").font(.headline).foregroundColor(.plantText)
            Text("Add a plant in My Plants to start tracking its growth.").font(.subheadline).foregroundColor(.black).multilineTextAlignment(.center)
        }.padding(40)
    }

    private func value(of entry: GrowthEntry) -> Double { metric == .height ? entry.height : Double(entry.leaves) }
    private func cm(_ v: Double) -> String { v.truncatingRemainder(dividingBy: 1) == 0 ? "\(Int(v)) cm" : String(format: "%.1f cm", v) }
}

private struct AddGrowthSheet: View {
    let plantName: String
    let onSave: (Double, Int) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var height: Double
    @State private var leaves: Int

    init(plantName: String, height: Double, leaves: Int, onSave: @escaping (Double, Int) -> Void) {
        self.plantName = plantName; self.onSave = onSave
        _height = State(initialValue: height); _leaves = State(initialValue: leaves)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.plantBackground.ignoresSafeArea()
                VStack(spacing: 16) {
                    counter(title: "Height", icon: "ruler", value: String(format: "%.1f cm", height), minus: { height = max(0.5, height - 0.5) }, plus: { height += 0.5 })
                    counter(title: "Leaves", icon: "leaf.fill", value: "\(leaves)", minus: { leaves = max(0, leaves - 1) }, plus: { leaves += 1 })
                    Spacer()
                    Button {
                        onSave(height, leaves); dismiss()
                    } label: {
                        Text("Save measurement").font(.headline).foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 15)
                            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.plantPrimary))
                    }
                }.padding(20)
            }
            .navigationTitle(plantName).navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() } } }
        }.presentationDetents([.medium])
    }

    private func counter(title: String, icon: String, value: String, minus: @escaping () -> Void, plus: @escaping () -> Void) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon).foregroundColor(.plantPrimary).frame(width: 44, height: 44).background(Color.plantPrimary.opacity(0.12)).clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.caption).foregroundColor(.black)
                Text(value).font(.system(.title2, design: .rounded).weight(.bold)).foregroundColor(.plantText)
            }
            Spacer()
            HStack(spacing: 0) {
                Button(action: minus) { Image(systemName: "minus").frame(width: 46, height: 40) }
                Button(action: plus) { Image(systemName: "plus").frame(width: 46, height: 40) }
            }.font(.subheadline.weight(.bold)).foregroundColor(.plantText).background(Capsule().fill(Color.plantBackground))
        }.padding(16).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}