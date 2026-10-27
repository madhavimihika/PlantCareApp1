import SwiftUI

struct AddPlantView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var plantName = ""
    @State private var botanicalName = ""
    @State private var location = "Bedroom"
    
    // Connect to the shared ViewModel
    @ObservedObject var viewModel = MyPlantsViewModel.shared
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Plant Details")) {
                    TextField("Name (e.g., Monstera)", text: $plantName)
                    TextField("Botanical Name (optional)", text: $botanicalName)
                    TextField("Location (e.g., Living Room)", text: $location)
                }
                
                Section {
                    Button("Save Plant") {
                        viewModel.addPlant(
                            name: plantName.isEmpty ? "New Plant" : plantName,
                            botanicalName: botanicalName.isEmpty ? "Unknown" : botanicalName,
                            location: location
                        )
                        dismiss()
                    }
                }
            }
            .navigationTitle("Add New Plant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}