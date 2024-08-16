//
//  Conversation.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/16/24.
//

import Foundation

public struct Conversation: Identifiable, Hashable {
    public let id: String
    public let users: [User]
    public let isGroup: Bool
    public let pictureURL: URL?
    public let title: String
    public let latestMessage: LatestMessageInChat?
}

public struct LatestMessageInChat: Hashable {
    public var senderName: String
    public var createdAt: Date?
    public var text: String?
    public var subtext: String?

//    var isMyMessage: Bool {
//        SessionManager.currentUser?.name == senderName
//    }
}
