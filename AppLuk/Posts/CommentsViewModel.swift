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
    var knowledgeId: String

    init(knowledgeId: String) {
        self.knowledgeId = knowledgeId
    }

    func getComments() {
        let db = Firestore.firestore()
        db.collection("knowledges").document(knowledgeId).collection("comments")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching comments: \(error!)")
                    return
                }

                let comments = documents.compactMap { document in
                    do {
                        return try document.data(as: Comment.self)
                    } catch {
                        return nil
                    }
                }

                self.comments = comments
            }
    }

    func postComment(text: String) {
        let db = Firestore.firestore()
        let comment = Comment(postedById: DataStorageManager.shared.currentUserId, postedAt: .now, text: text)
        print("DEBUG: \(knowledgeId)")
        do {
            try db.collection("knowledges").document(knowledgeId).collection("comments").addDocument(from: comment)
        } catch {
            print("Error posting comment \(error)")
        }
    }
}
