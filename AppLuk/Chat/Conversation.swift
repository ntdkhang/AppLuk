//
//  Conversation.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/16/24.
//

import FirebaseFirestore
import Foundation

public struct Conversation: Codable, Identifiable, Hashable {
    @DocumentID public var id: String?
    public let usersId: [String]
}

public struct LatestMessageInChat: Codable, Hashable {
    public var senderName: String
    public var createdAt: Date?
    public var text: String?
    public var subtext: String?

//    var isMyMessage: Bool {
//        SessionManager.currentUser?.name == senderName
//    }
}

// public struct FirestoreConversation: Codable, Identifiable, Hashable {
//    @DocumentID public var id: String?
//    public let users: [String]
//    public let title: String
//    public let latestMessage: FirestoreMessage?
// }
