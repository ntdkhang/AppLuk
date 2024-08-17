//
//  ConversationViewModel.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/16/24.
//

import FirebaseFirestore
import Foundation

class ConversationViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var conversation: Conversation
    @Published var imageUrl: URL? // partner's avatar image url

    init(conversation: Conversation) {
        self.conversation = conversation
    }

    func getConversation() async {
        let db = Firestore.firestore()
        db.collection("conversations").document(conversation.id ?? "").collection("messages")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }

                let messages = documents.compactMap { document in
                    do {
                        let message = try document.data(as: Message.self)
                        return message
                    } catch {
                        print(error)
                    }
                    return nil
                }
                self.messages = messages
            }
    }
}
