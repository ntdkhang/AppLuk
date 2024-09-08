//
//  FriendRequest.swift
//  AppLuk
//
//  Created by Khang Nguyen on 9/6/24.
//

import FirebaseFirestore
import Foundation

struct FriendRequest: Codable, Identifiable {
    @DocumentID var id: String?
    let fromId: String // id of person sending the request
    let toId: String // id of person receiving the request
}
