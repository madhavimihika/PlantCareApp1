//
//  ScanView.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//

import SwiftUI
import PhotosUI
import UIKit

struct ScanView: View {
    @StateObject private var camera = CameraService()
    @Environment(\.dismiss) private var dismiss

    @State private var isShowingResult = false
    @State private var isAnalyzing = false
    @State private var showTips = false
    @State private var pulse = false

    @State private var scannedDisease = "Unknown"
    @State private var scannedConfidence = 0.0
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                background

                LinearGradient(colors: [.black.opacity(0.65), .clear, .black.opacity(0.8)],
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)

                VStack(spacing: 0) {
                    topBar
                    Spacer()
                    reticle
                    hint
                    Spacer()
                    controls
                }

                if isAnalyzing { analyzingOverlay }
            }
            .animation(.easeInOut(duration: 0.25), value: isAnalyzing)
            .navigationBarHidden(true)
            // Don't stop the camera when we're only opening the result screen
            .onDisappear { if !isShowingResult { camera.stopCamera() } }
            // Coming back from the result screen: clear the old photo so the camera is live again
            .onChange(of: isShowingResult) { showing in
                if !showing { resetScan() }
            }
            .navigationDestination(isPresented: $isShowingResult) {
                ScanResultView(diseaseName: scannedDisease,
                               confidence: scannedConfidence,
                               image: selectedImage)
            }
            .sheet(isPresented: $showTips) { ScanTipsSheet() }
        }
    }

    //Pieces

    @ViewBuilder
    private var background: some View {
        if let image = selectedImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea()
        } else {
            CameraPreviewView(camera: camera)
                .ignoresSafeArea()
        }
    }

    private var topBar: some View {
        HStack {
            circleButton(icon: "xmark") { closeTapped() }
            Spacer()
            Text("Plant scanner")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 9)
                .background(.ultraThinMaterial, in: Capsule())
            Spacer()
            circleButton(icon: "lightbulb.fill") { showTips = true }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    private var reticle: some View {
        CornerBrackets()
            .stroke(Color.white, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
            .frame(width: 260, height: 260)
            .scaleEffect(pulse ? 1.03 : 0.97)
            .shadow(color: .black.opacity(0.3), radius: 6)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                    pulse = true
                }
            }
    }

    private var hint: some View {
        Text("Keep one leaf inside the frame")
            .font(.footnote.weight(.medium))
            .foregroundColor(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial, in: Capsule())
            .padding(.top, 22)
    }

    private var controls: some View {
        HStack {
            PhotosPicker(selection: $selectedItem, matching: .images) {
                VStack(spacing: 6) {
                    Image(systemName: "photo.on.rectangle")
                        .font(.title2)
                    Text("Library")
                        .font(.caption)
                }
                .foregroundColor(.white)
                .frame(width: 64)
            }
            .onChange(of: selectedItem) { newItem in
                loadPicked(newItem)
            }

            Spacer()

            Button(action: capture) {
                ZStack {
                    Circle().stroke(Color.white, lineWidth: 4).frame(width: 86, height: 86)
                    Circle().fill(Color.white).frame(width: 68, height: 68)
                }
            }
            .buttonStyle(ShutterButtonStyle())
            .disabled(isAnalyzing)

            Spacer()

            Color.clear.frame(width: 64, height: 1)   // keeps the shutter centered
        }
        .padding(.horizontal, 36)
        .padding(.bottom, 28)
    }

    private var analyzingOverlay: some View {
        ZStack {
            Color.black.opacity(0.45).ignoresSafeArea()
            VStack(spacing: 14) {
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.4)
                Text("Analyzing leaf…")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(30)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
        .transition(.opacity)
    }

    private func circleButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(.ultraThinMaterial, in: Circle())
        }
    }

    //Actions

    private func closeTapped() {
        if selectedImage != nil || isAnalyzing {
            resetScan()          // clears the old photo and goes back to the live camera
        } else {
            dismiss()
        }
    }

    private func resetScan() {
        selectedImage = nil
        selectedItem = nil
        isAnalyzing = false
    }

    private func finish(_ disease: String, _ confidence: Double) {
        guard isAnalyzing else { return }
        scannedDisease = disease
        scannedConfidence = confidence
        isAnalyzing = false
        isShowingResult = true
    }

    private func capture() {
        guard !isAnalyzing else { return }
        isAnalyzing = true
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        camera.testModelWithImage()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if let result = camera.predictionResult {
                finish(result, camera.confidence)
            } else {
                finish("Unknown", 0.0)
            }
        }
    }

    private func loadPicked(_ item: PhotosPickerItem?) {
        guard let item = item else { return }
        Task {
            guard let data = try? await item.loadTransferable(type: Data.self),
                  let image = UIImage(data: data) else { return }
            await MainActor.run {
                selectedItem = nil
                selectedImage = image
                isAnalyzing = true
                camera.predictImage(image: image) { disease, confidence in
                    DispatchQueue.main.async { finish(disease, confidence) }
                }
                // Safety net: never leave the spinner stuck
                DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                    finish("Unknown", 0.0)
                }
            }
        }
    }
}

//Helpers

struct CornerBrackets: Shape {
    var length: CGFloat = 38

    func path(in rect: CGRect) -> Path {
        var p = Path()
        // top-left
        p.move(to: CGPoint(x: rect.minX, y: rect.minY + length))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.minX + length, y: rect.minY))
        // top-right
        p.move(to: CGPoint(x: rect.maxX - length, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + length))
        // bottom-right
        p.move(to: CGPoint(x: rect.maxX, y: rect.maxY - length))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.maxX - length, y: rect.maxY))
        // bottom-left
        p.move(to: CGPoint(x: rect.minX + length, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - length))
        return p
    }
}

struct ShutterButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct ScanTipsSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Better scans")
                .font(.system(.title3, design: .rounded).weight(.bold))
                .foregroundColor(.plantText)

            tip(icon: "sun.max.fill", text: "Use daylight. Avoid shadows and glare.")
            tip(icon: "leaf.fill", text: "Fill the frame with one leaf, up close.")
            tip(icon: "hand.raised.fill", text: "Hold steady so the photo isn't blurry.")
            tip(icon: "rectangle.on.rectangle", text: "A plain background gives clearer results.")

            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.plantBackground.ignoresSafeArea())
        .presentationDetents([.medium])
    }

    private func tip(icon: String, text: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundColor(.plantPrimary)
                .frame(width: 40, height: 40)
                .background(Color.plantPrimary.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            Text(text)
                .font(.subheadline)
                .foregroundColor(.plantText)
        }
    }
}