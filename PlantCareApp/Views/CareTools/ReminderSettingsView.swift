import SwiftUI

struct ReminderSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var notificationsEnabled = true
    @State private var reminderTime = Date()
    @State private var plantName = "Monstera"
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.plantBackground.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("REMINDERS").font(.caption).fontWeight(.bold).foregroundColor(.black)
                        Text("Never forget to care for your plants again.").font(.subheadline).foregroundColor(.black)
                        
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "bell.fill").foregroundColor(.plantPrimary).frame(width: 30)
                                Text("Enable Reminders").foregroundColor(.plantText)
                                Spacer()
                                Toggle("", isOn: $notificationsEnabled).tint(.plantPrimary)
                            }.padding()
                            
                            Divider().padding(.leading, 50)
                            
                            HStack {
                                Image(systemName: "clock.fill").foregroundColor(.plantPrimary).frame(width: 30)
                                Text("Reminder Time").foregroundColor(.plantText)
                                Spacer()
                                DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            }.padding()
                        }
                        .background(Color.white).clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        Button(action: {
                            NotificationService.shared.scheduleNotification(
                                title: "Time to water \(plantName)! ",
                                body: "Your plant needs some love today."
                            )
                        }) {
                            Text("Schedule Test Notification (5s)")
    .font(.headline).foregroundColor(.white).frame(maxWidth: .infinity).padding()
                                .background(Color.plantPrimary).clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                        .padding(.top, 10)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Remind & Scan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) { Image(systemName: "chevron.left").foregroundColor(.plantText) }
                }
            }
        }
    }
}