//
//  CameraPreviewView.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//

import Foundation
import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
    @ObservedObject var camera: CameraService
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        let previewLayer = AVCaptureVideoPreviewLayer(session: camera.session)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
