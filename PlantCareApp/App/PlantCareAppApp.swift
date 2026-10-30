//
//  PlantCareAppApp.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//
//
//  PlantCareAppApp.swift
//  PlantCareApp
//
//  Created by cobsccomp251p-24 on 2026-10-23.
//

import SwiftUI
import FirebaseCore
import UserNotifications // <-- ADD THIS

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate { // <-- ADD DELEGATE HERE
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure() //1

    NotificationService.shared.requestPermission() //2
      
    // ADD THIS LINE: Forces notifications to show while the app is open
    UNUserNotificationCenter.current().delegate = self 
      
    return true // return true at end 
  }
    
  // ADD THIS FUNCTION: Tells iOS to show the banner and play the sound
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      completionHandler([.banner, .sound])
  }
}

@main
struct PlantCareAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}