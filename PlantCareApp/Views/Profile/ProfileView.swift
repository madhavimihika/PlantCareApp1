import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @State private var userName = "User"
    @State private var userInitial = "U"
    @State private var notificationsEnabled = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.plantBackground.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        // Profile Header
                        VStack {
                            // Show the first letter of the name
                            Text(userInitial)
                                .font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                                .frame(width: 80, height: 80)
                                .background(Color.plantPrimary).clipShape(Circle())
                            
                            Text(userName).font(.title2).fontWeight(.bold)
                            Text("Plant Lover").font(.subheadline).foregroundColor(.gray)
                        }.padding(.top, 20)
                        
                        // Settings List
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "bell.fill").foregroundColor(.plantPrimary).frame(width: 30)
                                Text("Push Notifications")
                                Spacer()
                                Toggle("", isOn: $notificationsEnabled).tint(.plantPrimary)
                            }.padding()
                            
                            Divider().padding(.leading, 50)
                            
                            HStack {
                                Image(systemName: "clock.fill").foregroundColor(.plantPrimary).frame(width: 30)
                                Text("Notification Time")
                                Spacer()
                                Text("8:00 AM").foregroundColor(.gray)
                            }.padding()
                        }
                        .background(Color.white).clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        // Log Out
                        Button(action: { try? AuthService.shared.signOut() }) {
                            Text("Log Out").font(.headline).foregroundColor(.red)
                                .frame(maxWidth: .infinity).padding()
                                .background(Color.white).clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }.padding(20)
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                fetchUserData()
            }
        }
    }
    
    // Fetch the user from Firebase
    func fetchUserData() {
        if let user = Auth.auth().currentUser {
            if let displayName = user.displayName, !displayName.isEmpty {
                userName = displayName
            } else if let email = user.email {
                let namePart = email.components(separatedBy: "@").first ?? "User"
                userName = namePart.prefix(1).uppercased() + namePart.dropFirst()
            }
            
            // Set the initial letter for the circle
            if let firstChar = userName.first {
                userInitial = String(firstChar).uppercased()
            }
        }
    }
}