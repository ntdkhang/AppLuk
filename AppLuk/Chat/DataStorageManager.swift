//
//  DataStorageManager.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/16/24.
//

import FirebaseFirestore
import Foundation

class DataStorageManager: ObservableObject {
    @Published var friends: [User] = []
    let db = Firestore.firestore()
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

    func getFriends() async {
        guard let currentUser = currentUser else {
            print("Current user is nil")
            return
        }

        db.collection("users").whereField(FieldPath.documentID(), in: currentUser.friendsId)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                let friends = documents.compactMap { document in
                    do {
                        let friend = try document.data(as: User.self)
                        return friend
                    } catch {
                        print(error)
                        return nil
                    }
                }
                self.friends = friends
            }
    }

    func friend(withId: String) -> User? {
        return friends.first(where: { user in
            user.id == withId
        })
    }

    func getFriendName(withId: String) -> String {
        return friend(withId: withId)?.name ?? ""
    }
}
