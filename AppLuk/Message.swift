//
//  Message.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/16/24.
//

import Foundation

public struct Message: Identifiable, Hashable {
    public enum Status: Equatable, Hashable {
        case sending
        case sent
        case read
        case error
    }

    public var id: String // message ID

    public var fromId: String // sender ID
    public var toId: String // receipient ID

    // public var user: User
    public var status: Status?
    public var createdAt: Date

    public var text: String
}
