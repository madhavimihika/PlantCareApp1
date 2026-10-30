//
//  DashboardView.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//
//
//  DashboardView.swift
//  PlantCareApp
//

import SwiftUI

struct DashboardView: View {
    
    @StateObject private var viewModel = DashboardViewModel()
    
    @State private var completedTaskIDs: Set<AnyHashable> = []
    @State private var showLogoutConfirm = false

    private var userInitial: String {
        let name = "\(viewModel.userName)"
        return String(name.prefix(1)).uppercased()
    }

    private var doneCount: Int {
        viewModel.careTasks.filter { completedTaskIDs.contains(AnyHashable($0.id)) }.count
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.plantBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        headerSection
                        
                        // FIXED: Use the new dynamic GardenHealthCard
                        GardenHealthCard()
                        
                        weatherCard
                        careSection
                        logoutButton
                    }
                    .padding(20)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .confirmationDialog(
                "Log out of PlantCare?",
                isPresented: $showLogoutConfirm,
                titleVisibility: .visible
            ) {
                Button("Log Out", role: .destructive) {
                    try? AuthService.shared.signOut()
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }

    // Header
    private var headerSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.currentDate)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text("\(viewModel.greeting), \(viewModel.userName)")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color.plantText)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }

            Spacer()

            Text(userInitial)
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(Color.plantPrimary)
                .clipShape(Circle())
                .accessibilityHidden(true)
        }
        .padding(.top, 10)
    }

    // Weather
    private var weatherCard: some View {
        HStack(spacing: 14) {
            Image(systemName: "sun.max.fill")
                .font(.title2)
                .foregroundColor(.orange)
                .frame(width: 48, height: 48)
                .background(Color.orange.opacity(0.12))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text("Perfect growing day")
                    .font(.headline)
                    .foregroundColor(Color.plantText)
                Text("22° - Bright indirect light")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            Label("Sri Lanka", systemImage: "location.fill")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(16)
        .dashCardStyle()
    }

    // Today's care
    private var careSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Today's care")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color.plantText)

                    if !viewModel.careTasks.isEmpty {
                        Text("\(doneCount) of \(viewModel.careTasks.count) done")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }

                Spacer()

                NavigationLink(destination: CareToolsView()) {
                    Label("Care Tools", systemImage: "wrench.and.screwdriver.fill")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.plantPrimary)
                        .clipShape(Capsule())
                }
            }

            if viewModel.careTasks.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.largeTitle)
                        .foregroundColor(Color.plantPrimary)
                    Text("All caught up")
                        .font(.headline)
                        .foregroundColor(Color.plantText)
                    Text("No plants need care today.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .dashCardStyle()
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.careTasks) { task in
                        let isDone = completedTaskIDs.contains(AnyHashable(task.id))

                        Button {
                            withAnimation(.spring(duration: 0.3)) {
                                if isDone {
                                    completedTaskIDs.remove(AnyHashable(task.id))
                                } else {
                                    completedTaskIDs.insert(AnyHashable(task.id))
                                }
                            }
                        } label: {
                            HStack(spacing: 14) {
                                Image(systemName: isDone ? "checkmark" : "leaf.fill")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(Color.plantPrimary)
                                    .frame(width: 40, height: 40)
                                    .background(Color.plantBackground)
                                    .clipShape(Circle())

                                VStack(alignment: .leading, spacing: 3) {
                                    Text(task.plantName)
                                        .font(.headline)
                                        .foregroundColor(Color.plantText)
                                        .strikethrough(isDone)

                                    Label(task.location, systemImage: "mappin.and.ellipse")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                                    .font(.title2)
                                    .foregroundColor(isDone ? Color.plantPrimary : Color.gray.opacity(0.4))
                            }
                            .padding(16)
                            .dashCardStyle()
                            .opacity(isDone ? 0.65 : 1)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("\(task.plantName), \(task.location)")
                        .accessibilityValue(isDone ? "Done" : "Not done")
                        .accessibilityHint("Double tap to mark as done")
                    }
                }
                .sensoryFeedback(.selection, trigger: completedTaskIDs.count)
            }
        }
    }

    // Log out
    private var logoutButton: some View {
        Button {
            showLogoutConfirm = true
        } label: {
            Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                .font(.headline)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding()
                .dashCardStyle()
        }
        .padding(.top, 6)
    }
}

// Small helpers
private extension View {
    func dashCardStyle(radius: CGFloat = 18) -> some View {
        self
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
}