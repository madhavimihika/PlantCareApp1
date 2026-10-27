//
//  NurseriesViewModel.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//

import Foundation
import SwiftUI
import MapKit
import Combine

class NurseriesViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612), // Colombo
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @Published var nurseries: [Nursery] = [
        Nursery(name: "Floral Grubb Gardens", coordinate: CLLocationCoordinate2D(latitude: 6.9300, longitude: 79.8600), isOpen: true, closingTime: "6 PM"),
        Nursery(name: "Green Leaf Nursery", coordinate: CLLocationCoordinate2D(latitude: 6.9200, longitude: 79.8700), isOpen: true, closingTime: "5 PM"),
        Nursery(name: "Plant Paradise", coordinate: CLLocationCoordinate2D(latitude: 6.9350, longitude: 79.8500), isOpen: false, closingTime: "7 PM")
    ]
}

struct Nursery: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let isOpen: Bool
    let closingTime: String
}
