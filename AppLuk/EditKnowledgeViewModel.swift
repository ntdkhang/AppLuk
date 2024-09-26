//
//  EditKnowledgeViewModel.swift
//  AppLuk
//
//  Created by Khang Nguyen on 9/25/24.
//

import FirebaseFirestore
import Foundation
import SwiftUI

class EditKnowledgeViewModel: ObservableObject {
    @Published var contentPages: [String] = [""]
    @Published var scrollID: Int?

    @Published var title = ""
    @Published var tagsSelection = Set<String>()

    @Published var isFinished = false

    let knowledge: Knowledge

    init(knowledge: Knowledge) {
        self.knowledge = knowledge
        contentPages = knowledge.contentPages
        title = knowledge.title
        tagsSelection.formUnion(knowledge.tags)
    }

    // func newPage() {
    //     contentPages.append("")
    //     imageUrls.append(nil)
    //     images.append(nil)
    // }

    var pageCount: Int {
        contentPages.count
    }

    func edit(completion: @escaping () -> Void) {
        let db = Firestore.firestore()

        let knowledgeRef = db.collection("knowledges").document(knowledge.id ?? "")

        // post to database
        knowledgeRef.updateData([
            "contentPages": contentPages,
            "title": title,
            "tags": tagsSelection.sorted(),
        ]) { error in
            if error != nil {
                print(error!.localizedDescription)
            }
            completion()
        }
    }
}
