//
//  MyPlantsView.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//
//
//  MyPlantsView.swift
//  PlantCareApp
//
import SwiftUI

struct MyPlantsView: View {
    @StateObject private var viewModel = MyPlantsViewModel.shared
    @State private var showingAddPlant = false
    
    let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.plantBackground.ignoresSafeArea()
                VStack(spacing: 0) {
                    // Header FIX: Changed text color to .plantText
                    HStack {
                        Text("My Plants")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.plantText) // <-- Fixed visibility
                        Spacer()
                        Button(action: { showingAddPlant = true }) {
                            Image(systemName: "plus")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.plantPrimary)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20).padding(.top, 20).padding(.bottom, 10)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 20) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    FilterPill(title: "All", count: viewModel.allCount, isSelected: viewModel.selectedFilter == "All") { viewModel.selectedFilter = "All" }
                                    FilterPill(title: "Healthy", count: viewModel.healthyCount, isSelected: viewModel.selectedFilter == "Healthy") { viewModel.selectedFilter = "Healthy" }
                                    FilterPill(title: "Need care", count: viewModel.needsCareCount, isSelected: viewModel.selectedFilter == "Need care") { viewModel.selectedFilter = "Need care" }
                                }.padding(.horizontal, 20)
                            }
                            
                            if viewModel.filteredPlants.isEmpty {
                                VStack(spacing: 10) {
                                    Image(systemName: "leaf.circle").font(.system(size: 60)).foregroundColor(.gray.opacity(0.5))
                                    Text("No plants yet").font(.headline).foregroundColor(.plantText)
                                    Text("Tap the + button to add your first plant.").font(.subheadline).foregroundColor(.gray)
                                }.frame(maxWidth: .infinity).padding(.top, 50)
                            } else {
                                LazyVGrid(columns: columns, spacing: 16) {
                                    ForEach(viewModel.filteredPlants) { plant in
                                        NavigationLink(destination: PlantDetailView(plant: plant)) {
                                            PlantCardView(plant: plant)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }.padding(.horizontal, 20).padding(.bottom, 30)
                            }
                        }
                    }
                }
            }.navigationBarHidden(true)
            .sheet(isPresented: $showingAddPlant) { AddPlantView() }
        }
    }
}

struct FilterPill: View {
    let title: String; let count: Int; let isSelected: Bool; let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                Text("\(count)").font(.caption2).fontWeight(.bold)
                    .padding(.horizontal, 6).padding(.vertical, 2)
                    .background(isSelected ? Color.white.opacity(0.3) : Color.plantBackground).clipShape(Capsule())
            }
            .font(.subheadline).fontWeight(.semibold)
            .foregroundColor(isSelected ? .white : .plantText) // Fixed visibility
            .padding(.horizontal, 16).padding(.vertical, 10)
            .background(isSelected ? Color.plantPrimary : Color.white)
            .clipShape(Capsule())
        }
    }
}