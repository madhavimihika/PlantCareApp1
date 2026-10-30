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
    private let colombo = CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612)//cmb loc

    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    @Published var selectedID: Nursery.ID?

    @Published var nurseries: [Nursery] = [
        Nursery(name: "Flora Gardens",
                coordinate: CLLocationCoordinate2D(latitude: 6.9300, longitude: 79.8600),
                isOpen: true, closingTime: "6 PM",
                rating: 4.7, distance: "0.8 km", tags: ["Plant Doctor", "Pots"]),
        Nursery(name: "Green Leaf Nursery",
                coordinate: CLLocationCoordinate2D(latitude: 6.9200, longitude: 79.8700),
                isOpen: true, closingTime: "5 PM",
                rating: 4.5, distance: "1.6 km", tags: ["Indoor plants", "Soil"]),
        Nursery(name: "Plant Paradise",
                coordinate: CLLocationCoordinate2D(latitude: 6.9350, longitude: 79.8500),
                isOpen: false, closingTime: "7 PM",
                rating: 4.3, distance: "2.4 km", tags: ["Plant Doctor", "Seeds"])
    ]

    init() {
        selectedID = nurseries.first?.id
    }

    func select(_ nursery: Nursery) {
        withAnimation(.easeInOut(duration: 0.5)) {
            selectedID = nursery.id
            region = MKCoordinateRegion(center: nursery.coordinate, span: region.span)
        }
    }

    func recenter() {
        withAnimation(.easeInOut(duration: 0.5)) {
            region = MKCoordinateRegion(
                center: colombo,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        }
    }

    func openDirections(to nursery: Nursery) {
        let item = MKMapItem(placemark: MKPlacemark(coordinate: nursery.coordinate))
        item.name = nursery.name
        item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

struct Nursery: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let isOpen: Bool
    let closingTime: String
    let rating: Double
    let distance: String
    let tags: [String]
}