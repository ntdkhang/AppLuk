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
    static var currentUserId: String = ""
    static var currentUser: User? {
        shared.currentUser
    }

    @Published private var currentUser: User?

    func fetchCurrentUser() {
        Firestore.firestore().collection("users").document(DataStorageManager.currentUserId)
            .addSnapshotListener { snapshot, error in
                guard let document = snapshot else {
                    print("Error fetching current user: \(error!)")
                    return
                }
                do {
                    let user = try document.data(as: User.self)
                    self.currentUser = user
                } catch {
                    print("Error reading current user")
                }
            }
    }
}
