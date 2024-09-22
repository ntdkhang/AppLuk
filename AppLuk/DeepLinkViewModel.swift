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
    @Published var showComments = false

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
            self.showComments = true
        }
    }
}

enum DeepLinkTab: Hashable {
    case home
    case comment
    case addFriend
}
