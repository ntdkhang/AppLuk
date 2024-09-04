//
//  CreateKnowledgeViewModel.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/13/24.
//

import FirebaseFirestore
import FirebaseStorage
import Foundation
import PhotosUI
import SwiftUI

@MainActor
class CreateKnowledgeViewModel: ObservableObject {
    @Published var contentPages: [String] = [""]
    @Published var imageUrls: [URL?] = [nil]
    @Published var images: [UIImage?] = [nil]
    @Published var scrollID: Int?

    @Published var selectedItem: PhotosPickerItem? = nil {
        didSet {
            if let selectedItem {
                Task {
                    try await loadTransferable(from: selectedItem)
                }
            }
        }
    }

    @Published var title = ""
    @Published var tagsSelection = Set<String>()

    @Published var isFinished = false

    func loadTransferable(from imageSelection: PhotosPickerItem?) async throws {
        do {
            if let data = try await imageSelection?.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    images[scrollID ?? 0] = uiImage
                    selectedItem = nil
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func newPage() {
        contentPages.append("")
        imageUrls.append(nil)
        images.append(nil)
    }

    func removeCurrentImage() {
        images[scrollID ?? 0] = nil
    }

    var disableRemoveCurrentImage: Bool {
        images[scrollID ?? 0] == nil
    }

    var pageCount: Int {
        contentPages.count
    }

    func create() async {
        let db = Firestore.firestore()
        // create a new document, get ID
        let knowledgeRef = db.collection("knowledges").document()
        let knowledgeId = knowledgeRef.documentID
        // upload all images to storage, then retrieve the urls
        let urls = await uploadImages(knowledgeId: knowledgeId)

        // create a new post from the current items
        let knowledge = Knowledge(postedById: DataStorageManager.shared.currentUserId, title: title, contentPages: contentPages, imageUrls: urls, tags: tagsSelection.sorted())

        // post to database
        do {
            try knowledgeRef.setData(from: knowledge)
        } catch {
            print("Error posting knowledge: \(error)")
        }
    }

    private func uploadImages(knowledgeId: String) async -> [String?] {
        let storageRef = Storage.storage().reference(withPath: "/knowledge_images")

        do {
            return try await withThrowingTaskGroup(of: String?.self) { group in
                var urlsString = [String?]()

                for (index, uiImage) in self.images.enumerated() {
                    group.addTask(priority: .background) {
                        guard let uiImage = uiImage, let data = uiImage.jpegData(compressionQuality: 0.2) else {
                            return nil
                        }
                        let metadata = StorageMetadata()
                        metadata.contentType = "image/jpeg"
                        let _ = try await storageRef.child("\(knowledgeId + String(index)).jpeg").putDataAsync(data)
                        return try await storageRef.child("\(knowledgeId + String(index)).jpeg").downloadURL().absoluteString
                    }
                }

                for try await uploadedPhotoString in group {
                    urlsString.append(uploadedPhotoString)
                }

                return urlsString
            }
        } catch {
            print("Error uploading images: \(error)")
            return []
        }
    }
}
