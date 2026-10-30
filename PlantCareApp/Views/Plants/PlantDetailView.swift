import SwiftUI

struct PlantDetailView: View {
    var plant: Plant
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel = MyPlantsViewModel.shared

    var body: some View {
        NavigationStack {
            ZStack {
                Color.plantBackground.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        if let uiImage = PlantPhoto.load(name: plant.name) {
                            Image(uiImage: uiImage).resizable().scaledToFill().frame(height: 200).frame(maxWidth: .infinity).clipShape(RoundedRectangle(cornerRadius: 20))
                        } else {
                            Image(systemName: "leaf.fill").resizable().scaledToFit().frame(height: 80)
                                .foregroundColor(.plantPrimary).frame(height: 200).frame(maxWidth: .infinity)
                                .background(Color.plantPrimary.opacity(0.12)).clipShape(RoundedRectangle(cornerRadius: 20))
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            Text(plant.name).font(.largeTitle).fontWeight(.bold).foregroundColor(.plantText)
                            Text(plant.botanicalName).font(.subheadline).foregroundColor(.gray).italic()
                            Divider()
                            HStack {
                                Image(systemName: "mappin.circle.fill").foregroundColor(.plantPrimary)
                                Text(plant.location).foregroundColor(.plantText)
                            }.font(.subheadline)
                            HStack {
                                Image(systemName: "heart.fill").foregroundColor(.plantPrimary)
                                Text(plant.health.rawValue).foregroundColor(.plantText)
                            }.font(.subheadline)
                        }
                        .padding().frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white).clipShape(RoundedRectangle(cornerRadius: 20))

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Care tools").font(.system(.title3, design: .rounded).weight(.bold)).foregroundColor(.plantText)

                            NavigationLink(destination: WateringScheduleView(plant: plant)) {
                                careRow(kind: .watering)
                            }.buttonStyle(.plain)

                            NavigationLink(destination: FertilizerScheduleView(plant: plant)) {
                                careRow(kind: .fertilizer)
                            }.buttonStyle(.plain)

                            NavigationLink(destination: GrowthRecordsView(plant: plant)) {
                                shortcutRow(icon: "chart.line.uptrend.xyaxis", tint: .plantPrimary, title: "Growth records", subtitle: growthSubtitle)
                            }.buttonStyle(.plain)
                        }
                    }.padding(20)
                }
            }
            .navigationTitle("Plant details").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) { Image(systemName: "chevron.left").foregroundColor(.plantText) }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func careRow(kind: CareKind) -> some View {
        let days = viewModel.daysUntilDue(kind, for: plant)
        return shortcutRow(icon: kind.icon, tint: kind.tint, title: kind.title, subtitle: kind.statusText(days: days), subtitleColor: kind.statusColor(days: days))
    }

    private var growthSubtitle: String {
        let list = viewModel.growthEntries(for: plant)
        guard let last = list.last else { return "No measurements yet" }
        let height = last.height.truncatingRemainder(dividingBy: 1) == 0 ? "\(Int(last.height))" : String(format: "%.1f", last.height)
        return "Latest: \(height) cm • \(last.leaves) leaves"
    }

    private func shortcutRow(icon: String, tint: Color, title: String, subtitle: String, subtitleColor: Color = .secondary) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon).font(.headline).foregroundColor(tint).frame(width: 46, height: 46).background(tint.opacity(0.14)).clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.headline).foregroundColor(.plantText)
                Text(subtitle).font(.caption.weight(.medium)).foregroundColor(subtitleColor)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption.weight(.bold)).foregroundColor(.secondary.opacity(0.6))
        }
        .padding(14).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}