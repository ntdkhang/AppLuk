//
//  Message.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/16/24.
//

import FirebaseFirestore
import Foundation

public struct Message: Codable, Identifiable, Hashable {
    @DocumentID public var id: String? // message ID

    public var fromId: String // sender ID
    public var toId: String // receipient ID

    public var createdAt: Date

    public var text: String

    var isSender: Bool {
        fromId == DataStorageManager.currentUserId
    }
}

// public struct FirestoreMessage: Codable, Hashable {
//     @DocumentID public var id: String?
//     public var fromId: String
//     public var toId: String
//     @ServerTimestamp public var createdAt: Date?
//
//     public var text: String
// }
