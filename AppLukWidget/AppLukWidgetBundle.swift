//
//  AppLukWidgetBundle.swift
//  AppLukWidget
//
//  Created by Khang Nguyen on 8/31/24.
//

import FirebaseAuth
import FirebaseCore
import SwiftUI
import WidgetKit

@main
struct AppLukWidgetBundle: WidgetBundle {
    init() {
        FirebaseApp.configure()
//        do {
//            try Auth.auth().useUserAccessGroup("\(teamID).com.khang.nguyen.AppLuk.firebase")
//        } catch let error as NSError {
//            print("Error changing user access group in widget: \(error)")
//        }
    }

    var body: some Widget {
        AppLukWidget()
    }
}
