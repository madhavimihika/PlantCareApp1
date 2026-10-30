//
//  ScanResultView.swift
//  PlantCareApp
//

import SwiftUI

struct ScanResultView: View {
    var diseaseName: String
    var confidence: Double
    var image: UIImage? = nil

    @ObservedObject private var viewModel = MyPlantsViewModel.shared
    @Environment(\.dismiss) var dismiss

    // Reading the model's answer

    private var safeConfidence: Double { min(max(confidence, 0.0), 1.0) }
    private var isUnknown: Bool { diseaseName == "Unknown" || confidence <= 0 }
    private var isHealthy: Bool { diseaseName.lowercased().contains("healthy") }

    
    private var parts: (plant: String, condition: String) {
        let clean: (String) -> String = {
            $0.replacingOccurrences(of: "_", with: " ").trimmingCharacters(in: .whitespaces)
        }
        let pieces = diseaseName.components(separatedBy: "___")
        if pieces.count >= 2 { return (clean(pieces[0]), clean(pieces[1])) }
        return ("", clean(diseaseName))
    }

    private var historyName: String {
        parts.plant.isEmpty ? parts.condition : "\(parts.plant) – \(parts.condition)"
    }

    private var accent: Color {
        if isUnknown { return .gray }
        return isHealthy ? .green : .orange
    }

    private var chipText: String {
        if isUnknown { return "Not recognised" }
        return isHealthy ? "Looks healthy" : "Issue detected"
    }

    private var chipIcon: String {
        if isUnknown { return "questionmark.circle.fill" }
        return isHealthy ? "checkmark.seal.fill" : "exclamationmark.triangle.fill"
    }

    private var blurb: String {
        if isUnknown { return "We couldn't tell what this is. Try again with a clear, close photo of a single leaf." }
        if isHealthy { return "No disease found. Keep up your current care routine." }
        return "Our on-device model predicts this condition. Caught early, it often clears up with simple care."
    }

    private var steps: [(title: String, subtitle: String)] {
        if isUnknown {
            return [("Try a clearer photo", "Use daylight and avoid blur"),
                    ("Fill the frame", "Show one leaf up close"),
                    ("Use a plain background", "Then scan again")]
        }
        if isHealthy {
            return [("Keep your routine", "Water when the top soil feels dry"),
                    ("Give bright light", "Avoid harsh midday sun"),
                    ("Rescan monthly", "Catch problems early")]
        }
        return [("Remove affected leaves", "Cut with clean scissors"),
                ("Keep leaves dry", "Water the soil, not the leaves"),
                ("Improve airflow", "Then rescan in 7 days")]
    }

    // MARK: - Screen

    var body: some View {
        ZStack {
            Color.plantBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    header
                    resultCard
                    careCard
                    buttons
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Scan result")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        ZStack(alignment: .bottomLeading) {
            Group {
                if let photo = image {
                    Color.clear.overlay(
                        Image(uiImage: photo)
                            .resizable()
                            .scaledToFill()
                    )
                } else {
                    LinearGradient(colors: [Color.plantPrimary, Color.plantPrimary.opacity(0.5)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                        .overlay(
                            Image(systemName: "leaf.fill")
                                .font(.system(size: 64))
                                .foregroundColor(.white.opacity(0.5))
                        )
                }
            }
            .frame(height: 230)
            .clipped()

            LinearGradient(colors: [.clear, .black.opacity(0.6)], startPoint: .top, endPoint: .bottom)
                .frame(height: 230)

            VStack(alignment: .leading, spacing: 4) {
                if !parts.plant.isEmpty && !isUnknown {
                    Text(parts.plant)
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.white.opacity(0.85))
                }
                Text(isUnknown ? "Couldn't identify" : parts.condition)
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundColor(.white)
            }
            .padding(18)
        }
        .frame(height: 230)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 12, y: 6)
    }

    private var resultCard: some View {
        HStack(spacing: 18) {
            ZStack {
                Circle().stroke(accent.opacity(0.15), lineWidth: 10)
                Circle()
                    .trim(from: 0, to: isUnknown ? 0 : safeConfidence)
                    .stroke(accent, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 0) {
                    Text(isUnknown ? "–" : "\(Int(safeConfidence * 100))%")
                        .font(.system(.title3, design: .rounded).weight(.bold))
                        .foregroundColor(.plantText)
                    Text("sure")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 88, height: 88)

            VStack(alignment: .leading, spacing: 8) {
                Label(chipText, systemImage: chipIcon)
                    .font(.caption.weight(.bold))
                    .foregroundColor(accent)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(accent.opacity(0.12)))

                Text(blurb)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                if !isUnknown {
                    Text("Estimate from an on-device model, not a diagnosis.")
                        .font(.caption2)
                        .foregroundColor(.secondary.opacity(0.8))
                }
            }
            Spacer(minLength: 0)
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }

    private var careCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(isUnknown ? "FOR A BETTER SCAN" : (isHealthy ? "KEEP IT UP" : "RECOMMENDED CARE"))
                .font(.caption.weight(.bold))
                .foregroundColor(.secondary)

            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                TreatmentRow(number: "\(index + 1)", title: step.title, subtitle: step.subtitle)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }

    private var buttons: some View {
        VStack(spacing: 12) {
            if !isUnknown {
                Button {
                    viewModel.logActivity(action: "Scanned Plant",
                                          plantName: historyName,
                                          icon: "camera.viewfinder",
                                          color: .green)
                    NotificationService.shared.scheduleNotification(
                        title: "Scan saved",
                        body: "The scan for \(historyName) was added to your history."
                    )
                    dismiss()
                } label: {
                    Label("Save to care history", systemImage: "tray.and.arrow.down.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.plantPrimary))
                }
            }

            Button {
                dismiss()
            } label: {
                Text(isUnknown ? "Try again" : "Scan again")
                    .font(.headline)
                    .foregroundColor(isUnknown ? .white : .plantPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(isUnknown ? Color.plantPrimary : Color.plantPrimary.opacity(0.12))
                    )
            }
        }
    }
}

struct TreatmentRow: View {
    let number: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Text(number)
                .font(.subheadline.weight(.bold))
                .foregroundColor(.white)
                .frame(width: 26, height: 26)
                .background(Circle().fill(Color.plantPrimary))
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.plantText)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}