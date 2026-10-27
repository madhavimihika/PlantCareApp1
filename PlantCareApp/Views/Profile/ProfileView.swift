import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @State private var userName = "Maya"
    @State private var notificationsEnabled = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.plantBackground.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        // Profile Header
                        VStack {
                            Text("M")
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
        }
    }
}