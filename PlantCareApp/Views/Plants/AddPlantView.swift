import SwiftUI
import PhotosUI

struct AddPlantView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var plantName = ""
    @State private var botanicalName = ""
    @State private var location = "Bedroom"
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
    @ObservedObject var viewModel = MyPlantsViewModel.shared
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Plant Photo")) {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 150)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            HStack {
                                Image(systemName: "camera.fill")
                                Text("Add Photo")
                            }
                            .foregroundColor(.plantPrimary)
                        }
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                selectedImage = uiImage
                            }
                        }
                    }
                }
                
                Section(header: Text("Plant Details")) {
                    TextField("Name (e.g., Monstera)", text: $plantName)
                    TextField("Botanical Name (optional)", text: $botanicalName)
                    TextField("Location (e.g., Living Room)", text: $location)
                }
                
                Section {
                    Button(action: {
                        // Determine the final name
                        let finalName = plantName.isEmpty ? "New Plant" : plantName
                        
                        // Save the image using the FINAL name
                        if let image = selectedImage {
                            saveImageToDisk(image: image, name: finalName)
                        }
                        
                        // Save to Firestore
                        viewModel.addPlant(
                            name: finalName,
                            botanicalName: botanicalName.isEmpty ? "Unknown" : botanicalName,
                            location: location
                        )
                        
                        dismiss()
                    }) {
                        Text("Save Plant").font(.headline).frame(maxWidth: .infinity).foregroundColor(.white)
                    }
                    .listRowBackground(Color.plantPrimary)
                }
            }
            .navigationTitle("Add New Plant").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() } } }
        }
    }
    
    // Helper to save the image locally
    func saveImageToDisk(image: UIImage, name: String) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filePath = paths[0].appendingPathComponent("\(name).png")
        if let data = image.pngData() {
            try? data.write(to: filePath)
        }
    }
}