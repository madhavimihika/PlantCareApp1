import SwiftUI
import UIKit

struct CareScheduleView: View {
    let kind: CareKind
    let focusPlant: Plant?

    @ObservedObject private var viewModel = MyPlantsViewModel.shared
    @State private var selectedName: String?

    init(kind: CareKind, plant: Plant? = nil) {
        self.kind = kind
        self.focusPlant = plant
        _selectedName = State(initialValue: plant?.name)
    }

    private var sorted: [Plant] { viewModel.plantsSorted(by: kind) }

    private var hero: Plant? {
        if let name = selectedName, let match = viewModel.plants.first(where: { $0.name == name }) { return match }
        if let f = focusPlant { return f }
        return sorted.first
    }

    private var others: [Plant] {
        sorted.filter { $0.name != hero?.name }
    }

    var body: some View {
        ZStack {
            Color.plantBackground.ignoresSafeArea()
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        Color.clear.frame(height: 0).id("top")
                        if let current = hero {
                            summary
                            CareHeroCard(kind: kind, plant: current).id(current.name)
                            if !others.isEmpty {
                                Text("Other plants")
                                    .font(.system(.title3, design: .rounded).weight(.bold))
                                    .foregroundColor(.plantText)
                                VStack(spacing: 12) {
                                    ForEach(others, id: \.name) { other in
                                        CareRow(kind: kind, plant: other) {
                                            withAnimation(.easeInOut) {
                                                selectedName = other.name
                                                proxy.scrollTo("top", anchor: .top)
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            emptyState
                        }
                    }.padding(20)
                }
            }
        }
        .navigationTitle(kind.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var summary: some View {
        let due = viewModel.dueCount(kind)
        return HStack(spacing: 10) {
            Image(systemName: kind.icon)
                .foregroundColor(kind.tint)
                .frame(width: 34, height: 34)
                .background(Circle().fill(kind.tint.opacity(0.14)))
            Text(due == 0 ? "All \(viewModel.plants.count) plants are up to date" : "\(due) of \(viewModel.plants.count) plants \(kind.needsText)")
                .font(.subheadline.weight(.medium))
                .foregroundColor(.plantText)
            Spacer()
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "leaf.fill").font(.system(size: 44)).foregroundColor(.plantPrimary.opacity(0.6))
            Text("No plants yet").font(.headline).foregroundColor(.plantText)
            Text("Add a plant in My Plants and its \(kind.title.lowercased()) schedule will show up here.")
                .font(.subheadline).foregroundColor(.secondary).multilineTextAlignment(.center)
        }.frame(maxWidth: .infinity).padding(.vertical, 60)
    }
}

private struct CareHeroCard: View {
    let kind: CareKind
    let plant: Plant
    @ObservedObject private var viewModel = MyPlantsViewModel.shared
    @State private var justDone = false

    private var days: Int { viewModel.daysUntilDue(kind, for: plant) }
    private var interval: Int { viewModel.interval(kind, for: plant) }
    private var nextDate: Date { viewModel.nextDate(kind, for: plant) }

    var body: some View {
        VStack(spacing: 0) {
            banner
            details
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .shadow(color: Color.black.opacity(0.07), radius: 14, x: 0, y: 6)
    }

    private var banner: some View {
        LinearGradient(colors: [kind.tint.opacity(0.9), kind.tint.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(height: 150)
            .overlay(alignment: .topTrailing) {
                Image(systemName: kind.icon).font(.system(size: 110)).foregroundColor(.white.opacity(0.15)).rotationEffect(.degrees(-15)).offset(x: 10, y: -5)
            }
            .overlay(alignment: .bottomLeading) {
                HStack(spacing: 14) {
                    PlantPhoto(name: plant.name, size: 72, corner: 36).overlay(Circle().stroke(Color.white, lineWidth: 3))
                    VStack(alignment: .leading, spacing: 3) {
                        Text(plant.name).font(.system(.title3, design: .rounded).weight(.bold)).foregroundColor(.white)
                        Label(plant.location, systemImage: "mappin.circle.fill").font(.caption).foregroundColor(.white.opacity(0.9))
                    }
                    Spacer()
                }.padding(18)
            }.clipped()
    }

    private var details: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(kind.nextLabel).font(.caption.weight(.bold)).foregroundColor(.secondary)
                Text(kind.statusText(days: days)).font(.system(.title2, design: .rounded).weight(.bold)).foregroundColor(days < 0 ? .red : .plantText)
                Text(nextDate.formatted(.dateTime.weekday(.wide).month(.wide).day())).font(.subheadline).foregroundColor(.secondary)
            }
            Divider()
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Repeat").font(.caption).foregroundColor(.secondary)
                    Text(kind.intervalText(interval)).font(.headline).foregroundColor(.plantText)
                }
                Spacer()
                HStack(spacing: 0) {
                    stepButton(systemName: "minus", direction: -1)
                    stepButton(systemName: "plus", direction: 1)
                }.background(Capsule().fill(Color.plantBackground))
            }
            Button {
                viewModel.markDone(kind, for: plant)
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                withAnimation { justDone = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { withAnimation { justDone = false } }
            } label: {
                Label(justDone ? "Done!" : kind.doneButton, systemImage: justDone ? "checkmark.circle.fill" : kind.icon)
                    .font(.headline).foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 15)
                    .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(justDone ? Color.green : Color.plantPrimary))
            }
        }.padding(20)
    }

    private func stepButton(systemName: String, direction: Int) -> some View {
        Button {
            viewModel.setInterval(interval + direction * kind.intervalStep, kind, for: plant)
        } label: {
            Image(systemName: systemName).font(.subheadline.weight(.bold)).foregroundColor(.plantText).frame(width: 44, height: 38)
        }
    }
}

private struct CareRow: View {
    let kind: CareKind
    let plant: Plant
    let onSelect: () -> Void
    @ObservedObject private var viewModel = MyPlantsViewModel.shared
    private var days: Int { viewModel.daysUntilDue(kind, for: plant) }

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onSelect) {
                HStack(spacing: 12) {
                    PlantPhoto(name: plant.name, size: 50, corner: 14)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(plant.name).font(.headline).foregroundColor(.plantText)
                        Text(kind.statusText(days: days)).font(.caption.weight(.medium)).foregroundColor(kind.statusColor(days: days))
                    }
                    Spacer(minLength: 0)
                }.contentShape(Rectangle())
            }.buttonStyle(.plain)

            Button {
                viewModel.markDone(kind, for: plant)
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            } label: {
                Image(systemName: kind.icon).font(.subheadline.weight(.semibold)).foregroundColor(kind.tint).frame(width: 40, height: 40).background(Circle().fill(kind.tint.opacity(0.12)))
            }.accessibilityLabel(kind.doneButton)
        }.padding(14).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}