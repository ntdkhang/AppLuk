//
//  AppLukApp.swift
//  AppLuk
//
//  Created by Khang Nguyen on 7/28/24.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseMessaging
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )

        do {
            try Auth.auth().useUserAccessGroup("\(teamID).com.khang.nguyen.AppLuk.firebase")
        } catch let error as NSError {
            print("Error changing user access group in app: \(error)")
        }

        application.registerForRemoteNotifications()
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions
    {
        return [.sound, .badge, .banner, .list]
    }
}

extension AppDelegate: MessagingDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        // DataStorageManager.shared.fcmToken = fcmToken ?? ""
        if let id = Auth.auth().getUserID() {
            let db = Firestore.firestore()
            db.collection("fcmTokens").document(id).setData([
                "token": fcmToken ?? "",
            ])
        }

        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
}

@main
struct AppLukApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            AuthenticatedView {
                ContentView()
                    .onAppear {
                        // UINavigationBar.appearance().barTintColor = .red
                        UIBarButtonItem.appearance().tintColor = .white
                        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Comfortaa", size: 16)!], for: .normal)
                    }
            }
            .preferredColorScheme(.dark)
        }
    }
}
