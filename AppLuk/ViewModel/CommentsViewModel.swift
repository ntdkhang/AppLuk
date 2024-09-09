//
//  CommentsViewModel.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/21/24.
//

import FirebaseFirestore
import Foundation
import SwiftUI

class CommentsViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    var knowledge: Knowledge

    init(knowledge: Knowledge) {
        self.knowledge = knowledge
    }

    func getComments() {
        guard let knowledgeId = knowledge.id else { return }
        let db = Firestore.firestore()
        db.collection("knowledges").document(knowledgeId).collection("comments")
            .order(by: "timePosted")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching comments: \(error!)")
                    return
                }

                let comments = documents.compactMap { document in
                    do {
                        let comment = try document.data(as: Comment.self)
                        DataStorageManager.shared.fetchUser(withId: comment.postedById)
                        return comment
                    } catch {
                        return nil
                    }
                }

                self.comments = comments
            }
    }

    func postComment(text: String) {
        guard let knowledgeId = knowledge.id else { return }
        let db = Firestore.firestore()
        let comment = Comment(postedById: DataStorageManager.shared.currentUserId, timePosted: .now, text: text)
        do {
            try db.collection("knowledges").document(knowledgeId).collection("comments").addDocument(from: comment)
        } catch {
            print("Error posting comment \(error)")
        }
    }
}
