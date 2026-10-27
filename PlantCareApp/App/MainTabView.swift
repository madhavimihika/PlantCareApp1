//
//  MainTabView.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//
//
//  MainTabView.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Home", systemImage: "house.fill") }
            
            MyPlantsView()
                .tabItem { Label("My Plant", systemImage: "leaf.fill") }
            
            ScanView()
                .tabItem { Label("Scan", systemImage: "camera.viewfinder") }
            
            NurseriesView()
                .tabItem { Label("Nurseries", systemImage: "mappin.and.ellipse") }
            
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
        }
        .tint(.plantPrimary)
    }
}