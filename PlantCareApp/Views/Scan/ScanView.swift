//
//  ScanView.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//

import Foundation
import SwiftUI

import PhotosUI
struct ScanView: View {
    @StateObject private var camera = CameraService()
    
    // State to pass to the Result View
    @State private var isShowingResult = false
    @State private var scannedDisease = "Unknown"
    @State private var scannedConfidence = 0.0
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
    var body: some View {
        NavigationStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } else {
                CameraPreviewView(camera: camera)
                    .ignoresSafeArea()
            }
            ZStack {
                // 1. Camera Feed
                CameraPreviewView(camera: camera)
                    .ignoresSafeArea()
                
                // 2. Gradient Overlay
                LinearGradient(gradient: Gradient(colors: [.black.opacity(0.5), .clear, .black.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    // Top Bar
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "xmark").font(.title3).foregroundColor(.white)
                                .padding(12).background(Color.black.opacity(0.5)).clipShape(Circle())
                        }
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "info").font(.title3).foregroundColor(.white)
                                .padding(12).background(Color.black.opacity(0.5)).clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20).padding(.top, 50)
                    
                    Spacer()
                    
                    Text("Scan Plant to Predict\nDiseases")
                        .font(.title2).fontWeight(.bold).foregroundColor(.white).multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    // Reticle / Scanning Frame
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.5), lineWidth: 2)
                            .frame(width: 250, height: 250)
                        Circle().stroke(Color.white, lineWidth: 1).frame(width: 10, height: 10)
                    }
                    
                    Text("Hold steady one leaf inside the frame")
                        .font(.caption).foregroundColor(.white).padding(.top, 20)
                    
                    Spacer()
                    
                    // Bottom Controls
                    HStack {
//                        VStack {
//                            Image(systemName: "photo.on.rectangle").font(.title)
//                            Text("Library").font(.caption)
//                        }.foregroundColor(.white)
//                        
                        Spacer()
                        
                        ///capture btn
                        Button(action: {
                            // Testin run the ML model on the static image
                            camera.testModelWithImage()
                            
                            //ML to process, then navigate
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                if let result = camera.predictionResult {
                                    scannedDisease = result
                                    scannedConfidence = camera.confidence
                                } else {
                                    scannedDisease = "Unknown"
                                    scannedConfidence = 0.0
                                }
                                isShowingResult = true
                            }
                        }) {
                            Circle().fill(Color.white).frame(width: 80, height: 80)
                                .overlay(Circle().stroke(Color.gray.opacity(0.5), lineWidth: 4))
                        }
                        
                        Spacer()
                        // Replace the Library VStack with this:
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            VStack {
                                Image(systemName: "photo.on.rectangle").font(.title)
                                Text("Library").font(.caption)
                            }
                            .foregroundColor(.white)
                        }
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    selectedImage = uiImage
                                    // Run prediction immediately when image is picked
                                    camera.predictImage(image: uiImage) { disease, confidence in
                                        scannedDisease = disease
                                        scannedConfidence = confidence
                                        isShowingResult = true
                                    }
                                }
                            }
                        }
                        VStack {
                            Image(systemName: "bolt.slash.fill").font(.title)
                            Text("Auto").font(.caption)
                        }.foregroundColor(.white)
                    }
                    .padding(.horizontal, 40).padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
            .onDisappear { camera.stopCamera() }
            // Navigate to Result View
            .navigationDestination(isPresented: $isShowingResult) {
                ScanResultView(diseaseName: scannedDisease, confidence: scannedConfidence)
            }
        }
    }
}
