//
//  DeepLinkViewModel.swift
//  AppLuk
//
//  Created by Khang Nguyen on 9/20/24.
//

import FirebaseFirestore
import Foundation

class DeepLinkViewModel: ObservableObject {
    @Published var selectedTab: DeepLinkTab = .home
    @Published var knowledgeId: String = ""
    @Published var knowledge: Knowledge?

    func handleUrl(_ url: URL) {
        print("HandleUrl: \(url)")
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("Error: invalid url: \(url)")
            return
        }

        guard let action = components.host, action == "comment" else {
            print("Error: invalid url host")
            return
        }

        guard let knowledgeId = components.queryItems?.first(where: { $0.name == "knowledgeId" })?.value else {
            print("Error cannot retreive knowledgeId from URL: \(url)")
            return
        }

        selectedTab = .comment
        self.knowledgeId = knowledgeId

        DataStorageManager.shared.fetchKnowledge(withId: self.knowledgeId) { knowledge in
            self.knowledge = knowledge
        }
    }

    // func fetchKnowledge(withId: String, completion: @escaping (Knowledge, Comment) -> Void) {
    //     // let db =
    //     let knowledgeRef = db.collection("knowledges").document(withId)
    //     knowledgeRef.getDocument { document, error in
    //         guard let document = document else {
    //             print("Error fetching knowledge: \(error?.localizedDescription ?? "nil")")
    //             return
    //         }
    //
    //         do {
    //             let knowledge = try document.data(as: Knowledge.self)
    //             knowledgeRef.collection("comments")
    //             completion(knowledge)
    //         } catch {
    //             print("Error reading knowledge: \(error)")
    //         }
    //     }
    // }
}

enum DeepLinkTab: Hashable {
    case home
    case comment
    case addFriend
}
