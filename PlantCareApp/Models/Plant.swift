//
//  Plant.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//
import Foundation

enum PlantHealth: String, Codable {
    case healthy = "Health"
    case needsCare = "Needs care"
}

struct Plant: Identifiable, Codable {
    var id: String = UUID().uuidString
    let name: String
    let botanicalName: String
    let location: String
    let health: PlantHealth
    let imageName: String
}
//real data tracking new
 var nextWaterDate: Date = Date().addingTimeInterval(86400) 

 var nextFertilizeDate: Date = Date().addingTimeInterval(604800) //default:1