//
//  WidgetUser.swift
//  AppLukWidgetExtension
//
//  Created by Khang Nguyen on 9/26/24.
//

import FirebaseFirestore
import Foundation

struct WidgetUser: Codable, Hashable, Identifiable {
    @DocumentID public var id: String?
    let name: String
    let userName: String // unique
    let avatarUrl: String
    let friendsId: [String] // friend list (id)
    let savesId: [String] // saved knowledge list (id)

    var avatarURL: URL? {
        URL(string: avatarUrl)
    }
}
