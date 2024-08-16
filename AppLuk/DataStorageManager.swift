//
//  DataStorageManager.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/16/24.
//

import FirebaseFirestore
import Foundation

class DataStorageManager: ObservableObject {
    static var shared = DataStorageManager()

    @Published var conversations: [Conversation] = []

    // func getConversations() async {
    //
    // }
}
