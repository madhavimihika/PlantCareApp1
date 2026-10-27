//
//  ScanResultView.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//

import Foundation
import SwiftUI

struct ScanResultView: View {
    var diseaseName: String
    var confidence: Double
    
    
    var cleanDiseaseName: String {
        return diseaseName.replacingOccurrences(of: "___", with: " ")
            .replacingOccurrences(of: "_", with: " ")
    }
    
    var body: some View {
        ZStack {
            Color.plantBackground.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    // Image Header
                    ZStack(alignment: .bottomLeading) {
                        Color.gray.opacity(0.3).frame(height: 200).cornerRadius(20)
                        Text("Scanned Plant").font(.headline).foregroundColor(.white).padding()
                    }
                    
                    // Disease Card
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.orange)
                            Text(cleanDiseaseName).font(.title3).fontWeight(.bold)
                        }
                        
                        Text("Detected by Core ML").font(.caption).foregroundColor(.gray)
                        
                        HStack {
                            Text("Confidence").font(.subheadline).foregroundColor(.gray)
                            Spacer()
                            Text("\(Int(confidence * 100))%").font(.subheadline).fontWeight(.bold).foregroundColor(.plantPrimary)
                        }
                        
                        ProgressView(value: confidence).tint(.plantPrimary)
                        
                        HStack {
                            Text(confidence > 0.8 ? "High certainty" : "Low certainty")
                                .font(.caption).padding(6).background(confidence > 0.8 ? Color.green.opacity(0.1) : Color.orange.opacity(0.1)).cornerRadius(8)
                        }
                        
                        Text("Based on the image provided, our on-device model predicts this condition. Caught early, this usually clears up with simple care.")
                            .font(.footnote).foregroundColor(.gray)
                    }
                    .padding(20).background(Color.white).cornerRadius(20)
                    
                    // Treatment Steps
                    VStack(alignment: .leading, spacing: 15) {
                        Text("RECOMMENDED CARE").font(.caption).fontWeight(.bold).foregroundColor(.gray)
                        
                        TreatmentRow(number: "1", title: "Remove affected leaves", subtitle: "Cut with clean scissors")
                        TreatmentRow(number: "2", title: "Keep leaves dry", subtitle: "Water the soil, not the leaves")
                        TreatmentRow(number: "3", title: "Improve airflow", subtitle: "Then rescan in 7 days")
                    }
                    .padding(20).background(Color.white).cornerRadius(20)
                    
                    Button(action: {}) {
                        Text("Save to Care History").font(.headline).foregroundColor(.white).frame(maxWidth: .infinity).padding()
                            .background(Color.plantPrimary).cornerRadius(15)
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
                Text(title).font(.subheadline).fontWeight(.bold)
                Text(subtitle).font(.caption).foregroundColor(.gray)
            }
        }
    }
}
