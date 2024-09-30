//
//  UserKnowledgeViewModel.swift
//  AppLuk
//
//  Created by Khang Nguyen on 9/30/24.
//

import FirebaseFirestore
import Foundation

class UserKnowledgeViewModel: ObservableObject {
    @Published var knowledges: [Knowledge] = []
    var userId: String
    init(userId: String) {
        self.userId = userId
        Task {
            await queryKnowledges()
        }
    }

    @MainActor
    func queryKnowledges() async {
        do {
            let querySnapshot = try await Firestore.firestore().collection("knowledges")
                .whereField("postedById", isEqualTo: userId)
                .order(by: "timePosted", descending: true)
                .getDocuments()

            var userKnowledges = [Knowledge]()
            for document in querySnapshot.documents {
                do {
                    let knowledge = try document.data(as: Knowledge.self)
                    userKnowledges.append(knowledge)
                } catch {
                    print("Error mapping to user Knowledge: \(error)")
                }
            }
            knowledges = userKnowledges
        } catch {
            print("Error getting user knowledges: \(error)")
        }
    }
}
