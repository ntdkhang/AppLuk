//
//  AddFriendViewModel.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/30/24.
//

import FirebaseFirestore
import FirebaseFunctions
import Foundation

class AddFriendViewModel: ObservableObject {
    @Published var searchResults: [User] = []
    @Published var requestsSent: [FriendRequest] = [] // array of IDs of users who the current user has sent a friend request
    @Published var requestsReceived: [FriendRequest] = [] // array of IDs of users who the current user has received a friend request from

    @Published var requestedUsers: [User] = []

    init() {
        fetchFriendRequestsSent()
        fetchFriendRequestsReceived()
    }

    
    @Published var searchText: String = "" {
        didSet {
            Task {
                if searchText.count > 2 {
                    await queryUsers()
                } else if searchText == "" {
                    DispatchQueue.main.sync {
                        searchResults = requestedUsers
                    }
                }
            }
        }
    }

    @MainActor
    func queryUsers() async {
        do {
            let lowercased = searchText.lowercased()
            let querySnapshot = try await Firestore.firestore().collection("users")
                .whereField("userName", isGreaterThanOrEqualTo: lowercased)
                .whereField("userName", isLessThanOrEqualTo: lowercased + "\u{f8ff}")
                .getDocuments()

            var searchedUsers = [User]()
            for document in querySnapshot.documents {
                do {
                    let user = try document.data(as: User.self)
                    searchedUsers.append(user)
                } catch {
                    print("Error mapping to searched user: \(error)")
                }
            }

            searchResults = searchedUsers
        } catch {
            print("Error getting search knowledges: \(error)")
        }
    }

    func addFriend(_ user: User) {
        DataStorageManager.shared.addFriend(userId: user.id)
    }

    func isFriend(_ user: User) -> Bool {
        guard let id = user.id else {
            return false
        }
        if DataStorageManager.shared.friendsAndSelfId.contains(id) {
            return true
        }

        return false
    }

    func didSendRequestTo(_ user: User) -> Bool {
        guard let id = user.id else {
            return false
        }
        return requestsSent.contains { $0.toId == id }
    }

    func didReceiveRequestFrom(_ user: User) -> Bool {
        guard let id = user.id else {
            return false
        }
        return requestsReceived.contains { $0.fromId == id }
    }

    func fetchFriendRequestsSent() {
        Firestore.firestore().collection("friendRequests")
            .whereField("fromId", isEqualTo: DataStorageManager.shared.currentUserId)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching friend requests \(error!)")
                    return
                }

                let requests = documents.compactMap { document in
                    do {
                        let request = try document.data(as: FriendRequest.self)
                        return request
                    } catch {
                        print("Error reading friend request: \(error)")
                        return nil
                    }
                }

                self.requestsSent = requests
            }
    }

    func fetchFriendRequestsReceived() {
        Firestore.firestore().collection("friendRequests")
            .whereField("toId", isEqualTo: DataStorageManager.shared.currentUserId)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching friend requests \(error!)")
                    return
                }

                let requests = documents.compactMap { document in
                    do {
                        let request = try document.data(as: FriendRequest.self)
                        return request
                    } catch {
                        print("Error reading friend request: \(error)")
                        return nil
                    }
                }

                self.requestsReceived = requests
                DispatchQueue.main.async {
                    self.fetchUsersRequest()
                }
            }
    }

    @MainActor
    func fetchUsersRequest() {
        let requestsFromUserIds = requestsReceived.compactMap { $0.fromId }
        if requestsFromUserIds.count > 0 {
            Firestore.firestore().collection("users")
                .whereField(FieldPath.documentID(), in: requestsFromUserIds)
                .addSnapshotListener { snapshot, error in
                    guard let documents = snapshot?.documents else {
                        print("Error fetching requested users: \(error!)")
                        return
                    }

                    let users = documents.compactMap { document in
                        do {
                            let request = try document.data(as: User.self)
                            return request
                        } catch {
                            print("Error reading request user: \(error)")
                            return nil
                        }
                    }

                    self.requestedUsers = users
                    if self.searchText == "" {
                        self.searchResults = self.requestedUsers
                    }
                }
        }
    }
}
