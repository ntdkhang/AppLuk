//
//  SearchKnowledgeViewModel.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/29/24.
//

import FirebaseFirestore
import SwiftUI

class SearchKnowledgeViewModel: ObservableObject {
    @Published var knowledges: [Knowledge]
    @Published var selectedTag: String = "" {
        didSet {
            Task {
                await queryKnowledges()
            }
        }
    }

    init() {
        knowledges = [Knowledge]()
    }

    @MainActor
    func queryKnowledges() async {
        do {
            let querySnapshot = try await Firestore.firestore().collection("knowledges")
                .whereField("postedById", in: DataStorageManager.shared.friendsAndSelfId)
                .whereField("tags", arrayContains: selectedTag)
                .order(by: "timePosted", descending: true)
                .getDocuments()

            var searchedKnowledges = [Knowledge]()
            print("Count: \(querySnapshot.documents.count)")
            for document in querySnapshot.documents {
                do {
                    let knowledge = try document.data(as: Knowledge.self)
                    searchedKnowledges.append(knowledge)
                } catch {
                    print("Error mapping to saved Knowledge: \(error)")
                }
            }
            knowledges = searchedKnowledges
            print(knowledges.count)
        } catch {
            print("Error getting search knowledges: \(error)")
        }
    }
}
