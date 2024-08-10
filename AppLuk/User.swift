//
//  User.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/8/24.
//

import Foundation

struct User: Identifiable {
    var id = UUID()
    var name: String
    var avatar: URL?

    static var example_DK: User {
        .init(name: "Khang Nguyen")
    }
}
