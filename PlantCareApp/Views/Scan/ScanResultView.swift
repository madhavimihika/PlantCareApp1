//
//  ScanResultView.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//

import SwiftUI

struct ScanResultView: View {
    var diseaseName: String
    var confidence: Double
    
    // Clean up the string
    var cleanDiseaseName: String {
        return diseaseName.replacingOccurrences(of: "___", with: " ")
            .replacingOccurrences(of: "_", with: " ")
    }
    
    // FIX: Ensures confidence never goes above 100%
    var safeConfidence: Double {
        return min(max(confidence, 0.0), 1.0)
    }
    
    var body: some View {
        ZStack {
            Color.plantBackground.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    // Image Header
                    ZStack(alignment: .bottomLeading) {
                        Color.gray.opacity(0.3).frame(height: 200).clipShape(RoundedRectangle(cornerRadius: 20))
                        Text("Scanned Plant").font(.headline).foregroundColor(.white).padding()
                    }
                    
                    // Disease Card
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.orange)
                            // FIX: Added .foregroundColor(.plantText) so it's visible
                            Text(cleanDiseaseName)
                                .font(.title3).fontWeight(.bold).foregroundColor(.plantText)
                        }
                        
                        Text("Detected by Core ML").font(.caption).foregroundColor(.gray)
                        
                        HStack {
                            Text("Confidence").font(.subheadline).foregroundColor(.gray)
                            Spacer()
                            // FIX: Uses safeConfidence to prevent 123%
                            Text("\(Int(safeConfidence * 100))%")
                                .font(.subheadline).fontWeight(.bold).foregroundColor(.plantPrimary)
                        }
                        
                        // FIX: Uses safeConfidence
                        ProgressView(value: safeConfidence).tint(.plantPrimary)
                        
                        HStack {
                            Text(safeConfidence > 0.8 ? "High certainty" : "Low certainty")
                                .font(.caption).fontWeight(.bold)
                                .foregroundColor(safeConfidence > 0.8 ? .green : .orange)
                                .padding(.horizontal, 10).padding(.vertical, 5)
                                .background(safeConfidence > 0.8 ? Color.green.opacity(0.1) : Color.orange.opacity(0.1))
                                .clipShape(Capsule())
                        }
                        
                        Text("Based on the image provided, our on-device model predicts this condition. Caught early, this usually clears up with simple care.")
                            .font(.footnote).foregroundColor(.gray)
                    }
                    .padding(20).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    // Treatment Steps
                    VStack(alignment: .leading, spacing: 15) {
                        Text("RECOMMENDED CARE").font(.caption).fontWeight(.bold).foregroundColor(.gray)
                        
                        TreatmentRow(number: "1", title: "Remove affected leaves", subtitle: "Cut with clean scissors")
                        TreatmentRow(number: "2", title: "Keep leaves dry", subtitle: "Water the soil, not the leaves")
                        TreatmentRow(number: "3", title: "Improve airflow", subtitle: "Then rescan in 7 days")
                    }
                    .padding(20).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    Button(action: {}) {
                        Text("Save to Care History").font(.headline).foregroundColor(.white).frame(maxWidth: .infinity).padding()
                            .background(Color.plantPrimary).clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                }
                .padding(.horizontal, 20).padding(.bottom, 30)
            }
        }
        .navigationTitle("Scan Result")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TreatmentRow: View {
    let number: String; let title: String; let subtitle: String
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Text(number).font(.subheadline).fontWeight(.bold).foregroundColor(.white)
                .frame(width: 24, height: 24).background(Color.plantPrimary).clipShape(Circle())
            VStack(alignment: .leading, spacing: 4) {
                // FIX: Added .foregroundColor(.plantText) for visibility
                Text(title).font(.subheadline).fontWeight(.bold).foregroundColor(.plantText)
                Text(subtitle).font(.caption).foregroundColor(.gray)
            }
        }
    }
}