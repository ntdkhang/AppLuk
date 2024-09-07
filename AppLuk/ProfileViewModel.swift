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
    @Published var name: String = ""
    @Published var userName: String = ""
    @Published var image: UIImage?

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

    func downloadAvatar() {
    }
}
