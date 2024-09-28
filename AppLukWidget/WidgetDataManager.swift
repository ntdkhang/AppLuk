//
//  WidgetDataManager.swift
//  AppLuk
//
//  Created by Khang Nguyen on 9/5/24.
//

import FirebaseFirestore
import Foundation

class WidgetDataManager: ObservableObject {
    @Published var knowledge: Knowledge = .empty
    var currentUserId: String = "" // this ID is set from the Auth UID
}
