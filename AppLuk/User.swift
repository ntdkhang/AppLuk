//
//  User.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/8/24.
//

import Foundation

public struct User: Codable, Hashable, Identifiable {
    public let id: String
    public let name: String
    public let userName: String // unique
    public let avatar: URL?
    public let isCurrentUser: Bool

    static var example_DK: User {
        .init(id: "", name: "Khang Nguyen", userName: "vuatretrau", avatar: nil, isCurrentUser: true)
    }

    static var example_Sua: User {
        .init(id: "", name: "Sua Bui", userName: "noble", avatar: nil, isCurrentUser: false)
    }
}
