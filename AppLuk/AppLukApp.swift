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
        do {
            try Auth.auth().useUserAccessGroup("\(teamID).com.khang.nguyen.AppLuk.firebase")
        } catch let error as NSError {
            print("Error changing user access group in app: \(error)")
        }
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
