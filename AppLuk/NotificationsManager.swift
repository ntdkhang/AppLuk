//
//  NotificationsManager.swift
//  AppLuk
//
//  Created by Khang Nguyen on 9/15/24.
//

import Foundation
import UserNotifications

@MainActor
class NotificationsManager: ObservableObject {
    @Published var hasPermission = false

    init() {
        Task {
            await getAuthStatus()
        }
    }

    func request() async {
        do {
            hasPermission = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            print(error)
        }
    }

    func getAuthStatus() async {
        let status = await UNUserNotificationCenter.current().notificationSettings()
        switch status.authorizationStatus {
        case .authorized,
             .provisional,
             .ephemeral:
            hasPermission = true
        default:
            hasPermission = false
        }
    }
    // func sendPushNotification(payloadDict: [String: Any]) {
    //     let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
    //     var request = URLRequest(url: url)
    //     request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //     // get your **server key** from your Firebase project console under **Cloud Messaging** tab
    //     let key = NotFirebaseKey.key
    //     request.setValue("key=\(key)", forHTTPHeaderField: "Authorization")
    //     request.httpMethod = "POST"
    //     request.httpBody = try? JSONSerialization.data(withJSONObject: payloadDict, options: [])
    //     let task = URLSession.shared.dataTask(with: request) { data, response, error in
    //         guard let data = data, error == nil else {
    //             print(error ?? "")
    //             return
    //         }
    //         if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
    //             print("statusCode should be 200, but is \(httpStatus.statusCode)")
    //             print(response ?? "")
    //         }
    //         print("Notfication sent successfully.")
    //         let responseString = String(data: data, encoding: .utf8)
    //         print(responseString ?? "")
    //     }
    //     task.resume()
    // }
}
