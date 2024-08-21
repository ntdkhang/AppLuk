//
//  Comment.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/21/24.
//

import FirebaseFirestore
import Foundation

struct Comment: Codable, Identifiable {
    @DocumentID var id: String?
    var postedById: String
    var postedAt: Date

    var text: String
}
