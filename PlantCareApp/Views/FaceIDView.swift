import SwiftUI

struct FaceIDView: View {
    @Binding var isUnlocked: Bool
    @State private var isScanning = false
    
    var body: some View {
        ZStack {
            Color.plantBackground.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Image(systemName: "faceid")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.plantPrimary)
                    .symbolEffect(.pulse, options: .repeating, value: isScanning)
                
                Text("Face ID Required")
                    .font(.title2).fontWeight(.bold).foregroundColor(.plantText)
                
                Text("Unlock to access your plants.")
                    .font(.subheadline).foregroundColor(.gray)
                
                Button(action: {
                    isScanning = true
                    BiometricService.shared.authenticateUser { success in
                        if success {
                            isUnlocked = true
                        }
                        isScanning = false
                    }
                }) {
                    Text("Authenticate")
                        .font(.headline).foregroundColor(.white)
                        .frame(maxWidth: .infinity).padding()
                        .background(Color.plantPrimary).cornerRadius(16)
                        .padding(.horizontal, 40)
                }
            }
        }
    }
}