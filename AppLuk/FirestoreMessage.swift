//
//  FirestoreMessage.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/16/24.
//

import FirebaseFirestore
import Foundation

public struct FirestoreMessage: Codable, Hashable {
    @DocumentID public var id: String?
    public var fromId: String
    public var toId: String
    @ServerTimestamp public var createdAt: Date?

    public var text: String
}
