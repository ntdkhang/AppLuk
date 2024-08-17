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
    var db = Firestore.firestore()

    func getConversations() async {
        db.collection("conversations").whereField("usersId", arrayContains: DataStorageManager.currentUserId)
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
                    }
                    return nil
                }
                self.conversations = conversations
            }
    }
}
