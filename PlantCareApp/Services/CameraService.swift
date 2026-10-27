//
//  CameraService.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//

import AVFoundation
import SwiftUI
import Vision
import CoreML
import Combine
class CameraService: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var session = AVCaptureSession()
    @Published var predictionResult: String? = nil
    @Published var confidence: Double = 0.0
    
    private var output = AVCaptureVideoDataOutput()
    private var mlModel: VNCoreMLModel?
    
    // We add this to prevent the ML from running too fast and crashing the phone
    private var lastProcessedTime = Date()
    
    override init() {
        super.init()
        
        // Load your Core ML Model (PlantCareDisease)
        do {
            let config = MLModelConfiguration()
            // Make sure the name here matches your mlpackage file exactly
            let model = try PlantCareDisease(configuration: config).model
            mlModel = try VNCoreMLModel(for: model)
        } catch {
            print("Failed to load ML model: \(error)")
        }
        
        checkPermissions()
    }
    
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted { DispatchQueue.main.async { self.setupCamera() } }
            }
        default:
            break
        }
    }
    
    func setupCamera() {
        // Prevent running on Simulator to avoid crashes
        #if targetEnvironment(simulator)
        print("Camera not available on Simulator")
        return
        #endif

        do {
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                print("No camera device found")
                return
            }
            
            let input = try AVCaptureDeviceInput(device: device)
            
            session.beginConfiguration()
            if session.canAddInput(input) { session.addInput(input) }
            
            output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            if session.canAddOutput(output) { session.addOutput(output) }
            
            session.commitConfiguration()
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.session.startRunning()
            }
        } catch {
            print("Error setting up camera: \(error)")
        }
    }
    
    func stopCamera() {
        session.stopRunning()
    }
    // Function to test the ML model  w image
    func testModelWithImage() {
        guard let uiImage = UIImage(named: "test_leaf"),
              let ciImage = CIImage(image: uiImage),
              let model = mlModel else {
            print("Failed to load image or model")
            return
        }
        
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else { return }
            
//            DispatchQueue.main.async {
//                self?.predictionResult = topResult.identifier
//                self?.confidence = Double(topResult.confidence)
//                print("Prediction: \(topResult.identifier) - \(topResult.confidence)")
//            }
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        try? handler.perform([request])
    }
    // Function to predict disease from a user-selected UIImage
    func predictImage(image: UIImage, completion: @escaping (String, Double) -> Void) {
        guard let ciImage = CIImage(image: image), let model = mlModel else {
            completion("Unknown", 0.0)
            return
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                completion("Unknown", 0.0)
                return
            }
            completion(topResult.identifier, Double(topResult.confidence))
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        try? handler.perform([request])
    }
    // This is where the Core ML magic happens!
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        // Only process an image every 1 second to save battery and prevent lag
        let now = Date()
        guard now.timeIntervalSince(lastProcessedTime) > 1.0 else { return }
        lastProcessedTime = now
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
              let model = mlModel else { return }
        
        // Create a Vision request using your Core ML model
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else { return }
            
            // Update the UI on the main thread
            DispatchQueue.main.async {
                self?.predictionResult = topResult.identifier
                self?.confidence = Double(topResult.confidence)
            }
        }
        
        // Run the request on the image
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? handler.perform([request])
    }
}
