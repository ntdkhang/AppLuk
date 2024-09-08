//
//  ProfileViewModel.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/17/24.
//

import FirebaseFirestore
import FirebaseStorage
import Foundation
import PhotosUI
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var name: String = DataStorageManager.shared.currentUser?.name ?? ""
    @Published var username: String = DataStorageManager.shared.currentUser?.userName ?? ""
    @Published var usernameAvailable: Bool?

    let db = Firestore.firestore()

    @Published var selectedPhoto: PhotosPickerItem? = nil {
        didSet {
            if let selectedPhoto {
                Task {
                    try await loadTransferable(from: selectedPhoto)
                }
            }
        }
    }

    func loadTransferable(from imageSelection: PhotosPickerItem?) async throws {
        do {
            if let data = try await imageSelection?.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data),
               let imageData = uiImage.jpegData(compressionQuality: 0.6)
            {
                let storageRef = Storage.storage().reference().child("avatars/").child("\(DataStorageManager.shared.currentUserId).jpeg")
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpeg"
                storageRef.putData(imageData, metadata: metaData) { metadata, error in
                    guard let _ = metadata else {
                        print("Error uploading new avatar: \(error?.localizedDescription ?? "")")
                        return
                    }
                    // reload profile view
                    storageRef.downloadURL { url, error in
                        guard let url = url else { return }

                        DataStorageManager.shared.updateAvatar(newUrl: url.absoluteString)
                        self.objectWillChange.send()
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func saveName() async -> SaveResult {
        if username != DataStorageManager.shared.currentUser?.userName {
            // new username
            let countQuery = db.collection("users").whereField("userName", isEqualTo: username).count
            do {
                let snapshot = try await countQuery.getAggregation(source: .server)
                if Int(truncating: snapshot.count) > 0 {
                    usernameAvailable = false
                    return .notAvailable
                } else {
                    usernameAvailable = true
                    try await db.collection("users").document(DataStorageManager.shared.currentUserId).updateData([
                        "name": name,
                        "userName": username,
                    ])

                    return .success
                }
            } catch {
                print("Error changing name and userName: \(error)")
                return .other(error.localizedDescription)
            }
        } else {
            // same username
            // only change name
            do {
                try await db.collection("users").document(DataStorageManager.shared.currentUserId).updateData([
                    "name": name,
                ])
                return .success
            } catch {
                print("Error changing name: \(error)")
                return .other(error.localizedDescription)
            }
        }
    }

    enum SaveResult {
        case success
        case notAvailable
        case other(String)
    }
}
