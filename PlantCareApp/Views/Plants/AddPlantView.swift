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
                Section(header: Text("Plant Details")) {
                    TextField("Name (e.g., Monstera)", text: $plantName)
                    TextField("Botanical Name (optional)", text: $botanicalName)
                    TextField("Location (e.g., Living Room)", text: $location)
                }
                
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
                
                Section {
                    Button(action: {
                        viewModel.addPlant(name: plantName.isEmpty ? "New Plant" : plantName, botanicalName: botanicalName.isEmpty ? "Unknown" : botanicalName, location: location)
                        
                        viewModel.logActivity(action: "Added Plant", plantName: plantName, icon: "leaf.fill", color: .green)
                        
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
}
//remobved log activity from add plant view, as it was causing duplicate entries in the activity log. The log activity is now handled in the view modl