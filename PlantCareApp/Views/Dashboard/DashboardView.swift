//
//  DashboardView.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//
import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.plantBackground.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Header
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.currentDate)
                                .font(.subheadline).foregroundColor(.gray)
                            Text("\(viewModel.greeting), Maya")
                                .font(.system(size: 28, weight: .bold)).foregroundColor(.plantText)
                        }.padding(.top, 10)
                        
                        // Garden Health Card
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Garden health")
                                .font(.subheadline).fontWeight(.medium).foregroundColor(.white.opacity(0.9))
                            
                            Text("82%")
                                .font(.system(size: 48, weight: .bold)).foregroundColor(.white)
                            
                            // Custom Progress Bar
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    Capsule().frame(width: geometry.size.width, height: 10).foregroundColor(Color.white.opacity(0.2))
                                    Capsule().frame(width: geometry.size.width * 0.82, height: 10).foregroundColor(.white)
                                }
                            }.frame(height: 10)
                            
                            Text("4 healthy, 2 need care, 1 possible disease")
                                .font(.caption).foregroundColor(.white.opacity(0.8))
                        }
                        .padding(24)
                        .background(Color.plantPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(color: Color.plantPrimary.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        // Weather Card
                        HStack {
                            Image(systemName: "sun.max.fill").font(.title).foregroundColor(.orange)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Perfect growing day").font(.headline).foregroundColor(.plantText)
                                Text("22° - Bright indirect light").font(.caption).foregroundColor(.gray)
                            }
                            Spacer()
                            Text("Sri Lanka").font(.caption).foregroundColor(.gray)
                        }
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        // Today's Care
                        HStack {
                            Text("Today's care").font(.title3).fontWeight(.bold).foregroundColor(.plantText)
                            Spacer()
                            NavigationLink(destination: CareToolsView()) {
                                Text("Care Tools")
                                    .font(.caption).fontWeight(.bold).foregroundColor(.white)
                                    .padding(.horizontal, 12).padding(.vertical, 6)
                                    .background(Color.plantPrimary).clipShape(Capsule())
                            }
                        }
                        
                        VStack(spacing: 12) {
                            ForEach(viewModel.careTasks) { task in
                                HStack {
                                    Image(systemName: "leaf.fill")
                                        .foregroundColor(.plantPrimary).padding(10).background(Color.plantBackground).clipShape(Circle())
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(task.plantName).font(.headline).foregroundColor(.plantText)
                                        Text(task.location).font(.caption).foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: "circle").foregroundColor(.gray.opacity(0.5))
                                }
                                .padding(16).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                        }
                        
                        // Log Out
                        Button(action: { try? AuthService.shared.signOut() }) {
                            Text("Log Out")
                                .font(.headline).foregroundColor(.red)
                                .frame(maxWidth: .infinity).padding()
                                .background(Color.white).clipShape(RoundedRectangle(cornerRadius: 16))
                        }.padding(.top, 10)
                    }
                    .padding(20)
                }
            }
            .navigationBarHidden(true)
        }
    }
}