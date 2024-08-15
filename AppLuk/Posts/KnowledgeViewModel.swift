//
//  KnowledgeViewModel.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/13/24.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor
class KnowledgeViewModel: ObservableObject {
    @Published var contentPages: [String] = [""]
    @Published var imageUrls: [URL?] = [nil]
    @Published var images: [Image?] = [nil]
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

    func loadTransferable(from imageSelection: PhotosPickerItem?) async throws {
        do {
            if let data = try await imageSelection?.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    images[scrollID ?? 0] = Image(uiImage: uiImage)
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
}
