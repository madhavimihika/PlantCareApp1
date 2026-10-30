import SwiftUI

// The "Your garden is thriving" card for the dashboard.
// Everything on it comes from your real plants, so just use:  GardenHealthCard()
struct GardenHealthCard: View {
    @ObservedObject private var viewModel = MyPlantsViewModel.shared

    var body: some View {
        VStack(spacing: 18) {
            HStack(spacing: 18) {
                GardenRing(healthy: viewModel.healthyCount,
                           needsCare: viewModel.needsCareCount,
                           atRisk: viewModel.atRiskCount,
                           score: viewModel.gardenScore,
                           isEmpty: viewModel.plants.isEmpty)
                    .frame(width: 92, height: 92)

                VStack(alignment: .leading, spacing: 5) {
                    Text(viewModel.gardenTitle)
                        .font(.system(.headline, design: .rounded).weight(.bold))
                        .foregroundColor(.plantText)
                    Text(viewModel.gardenSubtitle)
                        .font(.caption)
                        .foregroundColor(.black)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
            }

            HStack(spacing: 10) {
                legend(count: viewModel.healthyCount, label: "Healthy", color: .plantPrimary)
                legend(count: viewModel.needsCareCount, label: "Need care", color: .orange)
                legend(count: viewModel.atRiskCount, label: "At risk", color: .red)
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 5)
    }

    private func legend(count: Int, label: String, color: Color) -> some View {
        VStack(spacing: 3) {
            Text("\(count)")
                .font(.system(.title3, design: .rounded).weight(.bold))
                .foregroundColor(color)
            Text(label)
                .font(.caption2.weight(.medium))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(color.opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

// Donut chart-into healthy /need care /at risk
struct GardenRing: View {
    let healthy: Int
    let needsCare: Int
    let atRisk: Int
    let score: Int
    let isEmpty: Bool

    private var total: Double { Double(healthy + needsCare + atRisk) }

    private func fraction(_ n: Int) -> Double {
        total == 0 ? 0 : Double(n) / total
    }

    var body: some View {
        let h = fraction(healthy)
        let n = fraction(needsCare)

        return ZStack {
            Circle().stroke(Color.gray.opacity(0.15), lineWidth: 12)

            segment(from: 0, to: h, color: .plantPrimary)
            segment(from: h, to: h + n, color: .orange)
            segment(from: h + n, to: 1, color: .red, show: atRisk > 0)

            if isEmpty {
                Image(systemName: "leaf.fill")
                    .font(.title2)
                    .foregroundColor(.plantPrimary.opacity(0.5))
            } else {
                VStack(spacing: 0) {
                    Text("\(score)%")
                        .font(.system(.title3, design: .rounded).weight(.bold))
                        .foregroundColor(.plantText)
                    Text("health")
                        .font(.system(size: 9))
                        .foregroundColor(.black)
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: score)
    }

    @ViewBuilder
    private func segment(from: Double, to: Double, color: Color, show: Bool = true) -> some View {
        if show && to > from {
            Circle()
                .trim(from: from, to: to)
                .stroke(color, style: StrokeStyle(lineWidth: 12, lineCap: .butt))
                .rotationEffect(.degrees(-90))
        }
    }
}