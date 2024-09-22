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
    @Published var knowledge: Knowledge
    var knowledgeId: String
    init(knowledge: Knowledge) {
        self.knowledge = knowledge
        knowledgeId = knowledge.id ?? ""
    }

    init(knowledgeId: String) {
        // THIS SHOULD ONLY BE USED BY THE DEEP LINK!!!!
        // Although the comments works fine, any attemp to access self.knowledge will result in a placeholder Knowledge
        print("If you are seeing this and no deep link is called, please double check")
        self.knowledgeId = knowledgeId
        knowledge = .empty
    }

    func getComments() {
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
        let db = Firestore.firestore()
        let comment = Comment(postedById: DataStorageManager.shared.currentUserId, timePosted: .now, text: text)
        do {
            try db.collection("knowledges").document(knowledgeId).collection("comments").addDocument(from: comment)
        } catch {
            print("Error posting comment \(error)")
        }
    }
}

/*
 class CommentsViewModel: ObservableObject {
     @Published var comments: [Comment] = []
     var knowledgeId: String

     init(knowledgeId: String) {
         self.knowledgeId = knowledgeId
     }

     func getComments() {
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
         let db = Firestore.firestore()
         let comment = Comment(postedById: DataStorageManager.shared.currentUserId, timePosted: .now, text: text)
         do {
             try db.collection("knowledges").document(knowledgeId).collection("comments").addDocument(from: comment)
         } catch {
             print("Error posting comment \(error)")
         }
     }
 }
 */
