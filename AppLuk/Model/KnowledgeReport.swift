//
//  KnowledgeReport.swift
//  AppLuk
//
//  Created by Khang Nguyen on 11/13/24.
//

import FirebaseFirestore
import Foundation

struct KnowledgeReport: Codable, Identifiable {
    @DocumentID var id: String?
    let reporterId: String
    let knowledgeId: String
    let reason: String
}
