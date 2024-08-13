//
//  User.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/8/24.
//

import Foundation

struct User: Identifiable {
    public let id = UUID()
    public let name: String
    public let avatar: URL?
    public let isCurrentUser: Bool

    static var example_DK: User {
        .init(name: "Khang Nguyen", avatar: nil, isCurrentUser: true)
    }

    static var example_Sua: User {
        .init(name: "Sua Bui", avatar: nil, isCurrentUser: false)
    }
}
