//
//  ConversationsViewModel.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/16/24.
//

import FirebaseFirestore
import Foundation

class ConversationsViewModel: ObservableObject {
    @Published var conversations: [Conversation] = []
    let db = Firestore.firestore()

    func getConversations() async {
        db.collection("conversations").whereField("usersId", arrayContains: DataStorageManager.shared.currentUserId)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }

                let conversations = documents.compactMap { document in
                    do {
                        let conversation = try document.data(as: Conversation.self)
                        return conversation
                    } catch {
                        print(error)
                        return nil
                    }
                }

                self.conversations = conversations
            }
    }

    func createConversation(from: FirestoreConversation) async -> Conversation? {
        guard let partner = await getUser(id: from.partnerId), let id = from.id else {
            return nil
        }
        return Conversation(id: id, usersId: from.usersId, partner: partner)
    }

    func getUser(id: String) async -> User? {
        let db = Firestore.firestore()
        let ref = db.collection("users").document(id)
        do {
            let document = try await ref.getDocument()
            if document.exists {
                let user = try document.data(as: User.self)
                return user
            } else {
                print("ERROR getting user")
                return nil
            }
        } catch {
            print("ERROR: \(error)")
            return nil
        }
    }
}
