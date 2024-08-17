//
//  Conversation.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/16/24.
//

import FirebaseFirestore
import Foundation

struct Conversation: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    let usersId: [String]
    let partner: User

    var partnerId: String {
        return usersId.first(where: { userId in
            userId != DataStorageManager.currentUserId
        }) ?? ""
    }
}

public struct FirestoreConversation: Codable, Identifiable, Hashable {
    @DocumentID public var id: String?
    public let usersId: [String]

    var partnerId: String {
        return usersId.first(where: { userId in
            userId != DataStorageManager.currentUserId
        }) ?? ""
    }
}

// public struct FirestoreConversation: Codable, Identifiable, Hashable {
//    @DocumentID public var id: String?
//    public let users: [String]
//    public let title: String
//    public let latestMessage: FirestoreMessage?
// }
