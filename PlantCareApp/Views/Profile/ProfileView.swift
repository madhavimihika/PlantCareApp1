import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @State private var userName = "User"
    @State private var userInitial = "U"
    @State private var userEmail = "loading@email.com"
    
    // Settings States
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var notificationTime = Date()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.plantBackground.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // Profile Header
                        VStack(spacing: 12) {
                            Text(userInitial)
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 90, height: 90)
                                .background(Color.plantPrimary)
                                .clipShape(Circle())
                                .shadow(color: Color.plantPrimary.opacity(0.3), radius: 10, x: 0, y: 5)
                            
                            VStack(spacing: 4) {
                                Text(userName)
                                    .font(.title2).fontWeight(.bold).foregroundColor(.plantText)
                                Text(userEmail)
                                    .font(.subheadline).foregroundColor(.gray)
                            }
                        }
                        .padding(.top, 20)
                        
                        // Account Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("ACCOUNT").font(.caption).fontWeight(.bold).foregroundColor(.gray).padding(.leading, 10)
                            
                            VStack(spacing: 0) {
                                SettingsRow(icon: "person.fill", title: "Edit Profile", color: .blue)
                                Divider().padding(.leading, 50)
                                SettingsRow(icon: "lock.fill", title: "Change Password", color: .orange)
                            }
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                        // Preferences Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("PREFERENCES").font(.caption).fontWeight(.bold).foregroundColor(.gray).padding(.leading, 10)
                            
                            VStack(spacing: 0) {
                                // Notifications Toggle
                                HStack {
                                    Image(systemName: "bell.fill").foregroundColor(.plantPrimary).frame(width: 30)
                                    Text("Push Notifications").foregroundColor(.plantText)
                                    Spacer()
                                    Toggle("", isOn: $notificationsEnabled).tint(.plantPrimary)
                                }.padding()
                                
                                Divider().padding(.leading, 50)
                                
                                //Notification Time
                                HStack {
                                    Image(systemName: "clock.fill").foregroundColor(.plantPrimary).frame(width: 30)
                                    Text("Notification Time").foregroundColor(.plantText)
                                    Spacer()
                                    DatePicker("", selection: $notificationTime, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                }.padding()
                                
                                Divider().padding(.leading, 50)
                                
                                //Dark Mode Toggle
                                HStack {
                                    Image(systemName: "moon.fill").foregroundColor(.purple).frame(width: 30)
                                    Text("Dark Mode").foregroundColor(.plantText)
                                    Spacer()
                                    Toggle("", isOn: $darkModeEnabled).tint(.plantPrimary)
                                }.padding()
                            }
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                        // Support Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("SUPPORT").font(.caption).fontWeight(.bold).foregroundColor(.gray).padding(.leading, 10)
                            
                            VStack(spacing: 0) {
                                SettingsRow(icon: "questionmark.circle.fill", title: "Help & Support", color: .green)
                                Divider().padding(.leading, 50)
                                SettingsRow(icon: "doc.text.fill", title: "Privacy Policy", color: .gray)
                            }
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                        // Log Out
                        Button(action: { try? AuthService.shared.signOut() }) {
                            Text("Log Out")
                                .font(.headline).foregroundColor(.red)
                                .frame(maxWidth: .infinity).padding()
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 30)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                fetchUserData()
            }
        }
    }
    
    //Fetch the user from Firebase
    func fetchUserData() {
        if let user = Auth.auth().currentUser {
            // Name
            if let displayName = user.displayName, !displayName.isEmpty {
                userName = displayName
            } else if let email = user.email {
                let namePart = email.components(separatedBy: "@").first ?? "User"
                userName = namePart.prefix(1).uppercased() + namePart.dropFirst()
            }
            
            // Initial
            if let firstChar = userName.first {
                userInitial = String(firstChar).uppercased()
            }
            
            // Email
            if let email = user.email {
                userEmail = email
            }
        }
    }
}

// Reusable t
struct SettingsRow: View {
    var icon: String
    var title: String
    var color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 30)
            Text(title).foregroundColor(.plantText)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
    }
}