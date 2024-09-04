//
//  AppLukApp.swift
//  AppLuk
//
//  Created by Khang Nguyen on 7/28/24.
//

import FirebaseAuth
import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        FirebaseApp.configure()
        return true
    }
}

@main
struct AppLukApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            AuthenticatedView {
                ContentView()
                    .task {
//                         do {
//                             try Auth.auth().signOut()
//                         } catch {
//                         }
                    }
            }
        }
    }
}
