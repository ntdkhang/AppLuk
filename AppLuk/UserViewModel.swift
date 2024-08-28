//
//  UserViewModel.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/17/24.
//

import FirebaseFirestore
import Foundation

class UserViewModel: ObservableObject {
    @Published var savedKnowledges: [Knowledge] = []
    let db = Firestore.firestore()
}
