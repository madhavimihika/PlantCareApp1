//
//  Nurseries.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//

import SwiftUI
import MapKit

struct NurseriesView: View {
    @StateObject private var viewModel = NurseriesViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // Map Component
                Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.nurseries) { nursery in
                    MapAnnotation(coordinate: nursery.coordinate) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                            .foregroundColor(.plantPrimary)
                    }
                }
                .ignoresSafeArea(edges: .top)
                
                // Bottom Sheet with Nursery List
                VStack(alignment: .leading, spacing: 10) {
                    Text("Nearby nurseries")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.top, 15)
                    
                    Text("\(viewModel.nurseries.count) places nearby")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.nurseries) { nursery in
                                NurseryCard(nursery: nursery)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
            }
            .navigationBarHidden(true)
        }
    }
}

struct NurseryCard: View {
    let nursery: Nursery
    
    var body: some View {
        HStack {
            // Placeholder image
            Color.plantSecondary.opacity(0.3)
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    Image(systemName: "leaf.fill")
                        .foregroundColor(.plantPrimary)
                )
            
            VStack(alignment: .leading, spacing: 5) {
                Text(nursery.name)
                    .font(.headline)
                
                HStack {
                    Text(nursery.isOpen ? "Open" : "Closed")
                        .foregroundColor(nursery.isOpen ? .green : .red)
                        .font(.caption)
                    
                    Text("• Closes \(nursery.closingTime)")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                
                HStack {
                    Text("Plant Doctor")
                        .font(.caption2)
                        .padding(4)
                        .background(Color.plantBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    Text("Plant Doctor")
                        .font(.caption2)
                        .padding(4)
                        .background(Color.plantBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            }
        }
        .padding(10)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
