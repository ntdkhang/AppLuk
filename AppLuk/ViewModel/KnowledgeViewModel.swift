//
//  KnowledgeViewModel.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/18/24.
//

import Foundation

class KnowledgeViewModel: ObservableObject {
    @Published var knowledge: Knowledge

    init(knowledge: Knowledge) {
        self.knowledge = knowledge
    }
}
