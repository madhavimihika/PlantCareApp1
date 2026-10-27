import SwiftUI

struct AddPlantView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var plantName = ""
    @State private var botanicalName = ""
    @State private var location = "Bedroom"
    
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