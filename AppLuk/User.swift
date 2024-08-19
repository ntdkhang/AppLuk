//
//  User.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/8/24.
//

import FirebaseFirestore
import Foundation

struct User: Codable, Hashable, Identifiable {
    @DocumentID public var id: String?
    let name: String
    let userName: String // unique
    let avatarUrl: String
    let friendsId: [String] // friend list (id)

    var isCurrentUser: Bool {
        id ?? "" == DataStorageManager.currentUserId
    }

    var avatarURL: URL? {
        URL(string: avatarUrl)
    }
}
