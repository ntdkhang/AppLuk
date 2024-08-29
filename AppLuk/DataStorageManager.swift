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
    @Published var friends: [User] = []
    @Published var currentUser: User?
    @Published var knowledges = [Knowledge]()
    @Published var savedKnowledges = [Knowledge]()

    var currentUserId: String = "" // this ID is set from the Auth UID

    let db = Firestore.firestore()

    var currentUserAvatarUrl: URL? {
        currentUser?.avatarURL
    }

    var friendsAndSelfId: [String] {
        var friendsId = currentUser?.friendsId ?? []
        print("Friends ID: \(friendsId)")
        friendsId.append(currentUserId)
        return friendsId
    }

    func saveKnowledge(knowledgeId: String?) {
        guard let knowledgeId = knowledgeId else {
            return
        }
        let ref = db.collection("users").document(currentUserId)
        if let currentUser = currentUser, !currentUser.savesId.contains(knowledgeId) {
            ref.updateData([
                "savesId": FieldValue.arrayUnion([knowledgeId]),
            ])
        }
    }

    func getSavedKnowledes() {
        guard let currentUser = currentUser else {
            print("Current user is nil")
            return
        }

        db.collection("knowledges")
            .whereField(FieldPath.documentID(), in: currentUser.savesId)
            .order(by: "timePosted", descending: true)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching saved knowledges: \(error!)")
                    return
                }

                let knowledges = documents.compactMap { document in
                    do {
                        let knowledge = try document.data(as: Knowledge.self)
                        return knowledge
                    } catch {
                        print("Error mapping to saved Knowledge: \(error)")
                        return nil
                    }
                }

                self.savedKnowledges = knowledges
            }
    }

    func getKnowledges() {
        db.collection("knowledges")
            .whereField("postedById", in: DataStorageManager.shared.friendsAndSelfId)
            .order(by: "timePosted", descending: true)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching knowledges: \(error!)")
                    return
                }

                let knowledges = documents.compactMap { document in
                    do {
                        let knowledge = try document.data(as: Knowledge.self)
                        return knowledge
                    } catch {
                        print("Error mapping to Knowledge: \(error)")
                        return nil
                    }
                }

                self.knowledges = knowledges
                self.getSavedKnowledes()
            }
    }

    func fetchCurrentUser() {
        Firestore.firestore().collection("users").document(DataStorageManager.shared.currentUserId)
            .addSnapshotListener { snapshot, error in
                guard let document = snapshot else {
                    print("Error fetching current user: \(error!)")
                    return
                }
                do {
                    let user = try document.data(as: User.self)
                    self.currentUser = user
                    // DataStorageManager.currentUserId = user.id ?? ""
                    self.getFriends()
                } catch {
                    print("Error reading current user")
                }
            }
    }

    func getFriends() {
        guard let currentUser = currentUser else {
            print("Current user is nil")
            return
        }

        db.collection("users")
            .whereField(FieldPath.documentID(), in: currentUser.friendsId)
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
                        print("Error reading friends: \(error)")
                        return nil
                    }
                }
                self.friends = friends
                self.getKnowledges()
            }
    }

    func user(withId: String) -> User? {
        if withId == currentUserId {
            return currentUser
        }
        let user = friends.first(where: { user in
            user.id == withId
        })
        // TODO: if cannot find in friends, then query the User with that Id, and add the user to friends array
        return user
    }

    func getFriendName(withId: String) -> String {
        return user(withId: withId)?.name ?? ""
    }

    func getFriendAvatarUrl(withId: String) -> URL? {
        return user(withId: withId)?.avatarURL
    }
}
