import SwiftUI
import UIKit

//The Photo Loader
struct PlantPhoto: View {
    let name: String
    var size: CGFloat = 50
    var corner: CGFloat = 12

    var body: some View {
        Group {
            if let image = PlantPhoto.load(name: name) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "leaf.fill")
                    .font(.system(size: size * 0.4))
                    .foregroundColor(.plantPrimary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.plantPrimary.opacity(0.12))
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
    }

    static func load(name: String) -> UIImage? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filePath = paths[0].appendingPathComponent("\(name).png")
        return UIImage(contentsOfFile: filePath.path)
    }
}

// The Grid Card
struct ToolCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    var badge: Int = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                Image(systemName: icon)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(iconColor)
                    .frame(width: 46, height: 46)
                    .background(iconColor.opacity(0.14))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                Spacer()
                if badge > 0 {
                    Text("\(badge)")
                        .font(.caption.weight(.bold))
                        .foregroundColor(.white)
                        .frame(minWidth: 18)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(Color.red))
                }
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.plantText)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 132, alignment: .topLeading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
    }
}

// 3. The small care chips
struct PlantCareStatusRow: View {
    let plant: Plant

    var body: some View {
        HStack(spacing: 8) {
            CareChip(kind: .watering, plant: plant)
            CareChip(kind: .fertilizer, plant: plant)
        }
    }
}

struct CareChip: View {
    let kind: CareKind
    let plant: Plant
    @ObservedObject private var viewModel = MyPlantsViewModel.shared

    private var days: Int { viewModel.daysUntilDue(kind, for: plant) }

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: kind.icon)
            Text(kind.shortStatus(days: days))
        }
        .font(.caption2.weight(.semibold))
        .foregroundColor(days < 0 ? .red : kind.tint)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Capsule().fill((days < 0 ? Color.red : kind.tint).opacity(0.12)))
    }
}