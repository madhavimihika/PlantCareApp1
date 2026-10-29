//
//  Nurseries.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//
//
//  Nurseries.swift
//  PlantCareApp
//

import SwiftUI
import MapKit

//Screen

struct NurseriesView: View {
    @StateObject private var viewModel = NurseriesViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                map
                VStack(spacing: 0) {
                    header
                    Spacer()
                    carousel
                }
            }
            .navigationBarHidden(true)
        }
    }

    //Map with custom pins
    private var map: some View {
        Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.nurseries) { nursery in
            MapAnnotation(coordinate: nursery.coordinate) {
                NurseryPin(name: nursery.name,
                           isSelected: viewModel.selectedID == nursery.id)
                    .onTapGesture { viewModel.select(nursery) }
            }
        }
        .ignoresSafeArea()
    }

    //Floating title bar
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Nearby nurseries")
                    .font(.system(.title3, design: .rounded).weight(.bold))
                Text("\(viewModel.nurseries.count) places near you")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button {
                viewModel.recenter()
            } label: {
                Image(systemName: "location.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                    .frame(width: 38, height: 38)
                    .background(Circle().fill(Color.plantPrimary))
            }
            .accessibilityLabel("Recenter map")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    //Horizontal list of cards
    private var carousel: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(viewModel.nurseries) { nursery in
                        NurseryCard(nursery: nursery,
                                    isSelected: viewModel.selectedID == nursery.id,
                                    onDirections: { viewModel.openDirections(to: nursery) })
                            .id(nursery.id)
                            .onTapGesture { viewModel.select(nursery) }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 16)
            }
            .onChange(of: viewModel.selectedID) { id in
                guard let id else { return }
                withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                    proxy.scrollTo(id, anchor: .center)
                }
            }
        }
    }
}

//Map pin

struct NurseryPin: View {
    let name: String
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 4) {
            if isSelected {
                Text(name)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(Color.white))
                    .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
                    .transition(.scale.combined(with: .opacity))
            }

            ZStack {
                Circle()
                    .fill(isSelected ? Color.plantPrimary : Color.white)
                    .frame(width: isSelected ? 46 : 36, height: isSelected ? 46 : 36)
                    .shadow(color: .black.opacity(0.2), radius: 5, y: 2)
                Image(systemName: "leaf.fill")
                    .font(.system(size: isSelected ? 20 : 16))
                    .foregroundColor(isSelected ? .white : .plantPrimary)
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isSelected)
    }
}
//card

struct NurseryCard: View {
    let nursery: Nursery
    let isSelected: Bool
    let onDirections: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            banner
            details
        }
        .frame(width: 280)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(isSelected ? Color.plantPrimary : Color.clear, lineWidth: 2)
        )
        .shadow(color: .black.opacity(isSelected ? 0.18 : 0.08), radius: isSelected ? 14 : 8, y: 4)
        .scaleEffect(isSelected ? 1.0 : 0.96)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isSelected)
    }

    // Top image area (swap the gradient for a real photo later)
    private var banner: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(colors: [Color.plantPrimary, Color.plantSecondary],
                           startPoint: .topLeading, endPoint: .bottomTrailing)

            Image(systemName: "leaf.fill")
                .font(.system(size: 80))
                .foregroundColor(.white.opacity(0.18))
                .rotationEffect(.degrees(-20))
                .offset(x: 190, y: 10)

            HStack {
                statusBadge
                Spacer()
                ratingBadge
            }
            .padding(12)
        }
        .frame(height: 96)
    }

    private var statusBadge: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(nursery.isOpen ? Color.green : Color.red)
                .frame(width: 7, height: 7)
            Text(nursery.isOpen ? "Open" : "Closed")
                .font(.caption.weight(.semibold))
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Capsule().fill(Color.white.opacity(0.92)))
    }

    private var ratingBadge: some View {
        HStack(spacing: 3) {
            Image(systemName: "star.fill")
                .font(.caption2)
                .foregroundColor(.yellow)
            Text(String(format: "%.1f", nursery.rating))
                .font(.caption.weight(.semibold))
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Capsule().fill(Color.white.opacity(0.92)))
    }

    private var details: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text(nursery.name)
                    .font(.system(.headline, design: .rounded))
                    .lineLimit(1)

                HStack(spacing: 6) {
                    Label(nursery.distance, systemImage: "figure.walk")
                    Text("•")
                    Text(nursery.isOpen ? "Closes \(nursery.closingTime)" : "Opens tomorrow")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }

            HStack(spacing: 6) {
                ForEach(nursery.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption2.weight(.medium))
                        .foregroundColor(.plantPrimary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color.plantPrimary.opacity(0.12)))
                }
            }

            Button(action: onDirections) {
                Label("Get directions", systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.plantPrimary))
            }
        }
        .padding(14)
    }
}