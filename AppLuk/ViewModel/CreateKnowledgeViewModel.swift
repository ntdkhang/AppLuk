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

    func create(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        // create a new document, get ID
        let knowledgeRef = db.collection("knowledges").document()
        let knowledgeId = knowledgeRef.documentID

        // upload all images to storage, then retrieve the urls
        uploadImages(knowledgeId: knowledgeId) { urls in
            // create a new post from the current items
            let knowledge = Knowledge(postedById: DataStorageManager.shared.currentUserId, title: self.title, contentPages: self.contentPages, imageUrls: urls, tags: self.tagsSelection.sorted())

            // post to database
            do {
                try knowledgeRef.setData(from: knowledge) { error in
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                    completion()
                }
            } catch {
                print("Error posting knowledge: \(error)")
            }
        }
    }

    private func uploadImages(knowledgeId: String, completion: @escaping ([String?]) -> Void) {
        let storageRef = Storage.storage().reference(withPath: "/knowledge_images")
        var urlsString = [String?](repeating: nil, count: images.count)
        let urlToDownLoad = images.filter { $0 != nil }.count
        var urlDownloaded = 0

        if urlToDownLoad == 0 {
            completion(urlsString)
            return
        }

        for (index, uiImage) in images.enumerated() {
            if let data = uiImage?.jpegData(compressionQuality: 0.6) {
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                let childRef = storageRef.child("\(knowledgeId)_\(index)")
                childRef.putData(data, metadata: metadata) { metadata, error in
                    if error != nil {
                        print("Error uploading knowledge image: \(error!.localizedDescription)")
                    } else {
                        childRef.downloadURL { url, error in
                            urlDownloaded += 1
                            if let url = url {
                                urlsString[index] = url.absoluteString
                            } else {
                                print("Error downloading knowledge image URL")
                            }

                            if urlDownloaded == urlToDownLoad {
                                completion(urlsString)
                            }
                        }
                    }
                }
            }
        }
    }
}
