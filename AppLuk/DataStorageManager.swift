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

    func unsaveKnowledge(knowledgeId: String?) {
        guard let knowledgeId = knowledgeId else {
            return
        }
        let ref = db.collection("users").document(currentUserId)
        if let currentUser = currentUser, currentUser.savesId.contains(knowledgeId) {
            ref.updateData([
                "savesId": FieldValue.arrayRemove([knowledgeId]),
            ])
        }
    }

    func addFriend(userId: String?) {
        guard let userId = userId else {
            print("Other person id is nil")
            return
        }
        let ref = db.collection("friendRequests").document()
        let friendRequest = FriendRequest(fromId: currentUserId, toId: userId)

        do {
            try ref.setData(from: friendRequest)
        } catch {
            print("Error sending friend request: \(error)")
            return
        }
        // let ref = db.collection("users").document(currentUserId)
        // ref.updateData([
        //     "friendsId": FieldValue.arrayUnion([userId]),
        // ])
    }

    func getSavedKnowledes() {
        guard let currentUser = currentUser else {
            print("Current user is nil")
            return
        }

        // because the array for query cannot be empty
        // Since we're checking before calling the function, this should never be empty
        let tempSavesId = currentUser.savesId.isEmpty ? ["VS7iKmF50v6HF2o6w07g"] : currentUser.savesId

        db.collection("knowledges")
            .whereField(FieldPath.documentID(), in: tempSavesId)
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
            .whereField("postedById", in: friendsAndSelfId)
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
                if let currentUser = self.currentUser, !currentUser.savesId.isEmpty {
                    self.getSavedKnowledes()
                }
            }
    }

    func fetchCurrentUser() {
        Firestore.firestore().collection("users").document(currentUserId)
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
        db.collection("users")
            .whereField(FieldPath.documentID(), in: friendsAndSelfId)
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
        // TODO: if cannot find in friends, then query the User with that Id from users collection
        return user
    }

    func getFriendName(withId: String) -> String {
        return user(withId: withId)?.name ?? ""
    }

    func getFriendAvatarUrl(withId: String) -> URL? {
        return user(withId: withId)?.avatarURL
    }

    func isSavedKnowledge(knowledge: Knowledge) -> Bool {
        guard let savesId = currentUser?.savesId else {
            return false
        }
        return savesId.contains(knowledge.id ?? "")
    }

    func createNewUser(id: String, user: User, completion: @escaping (Error?) -> Void) {
        do {
            try db.collection("users").document(id).setData(from: user) { error in
                completion(error)
            }
        } catch {
            print("Error creating new user: \(error)")
            completion(error)
        }
    }
}
