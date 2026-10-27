//
//  CareTask.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//
import Foundation

struct CareTask: Identifiable {
    let id = UUID()
    let plantName: String
    let botanicalName: String
    let location: String
    var isCompleted: Bool
}
