//
//  UserViewModel.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/17/24.
//

import FirebaseFirestore
import Foundation

class UserViewModel: ObservableObject {
    @Published var friends: [User] = []
    var you: User
    let db = Firestore.firestore()

    init(you: User) {
        self.you = you
    }

    func getFriends() async {
        db.collection("users").whereField(FieldPath.documentID(), in: you.friendsId)
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
}
