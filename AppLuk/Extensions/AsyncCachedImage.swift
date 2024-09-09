//
//  AsyncCachedImage.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/23/24.
//  credit to: [https://stackoverflow.com/questions/69214543/how-can-i-add-caching-to-asyncimage/77956449#77956449//]

// UPDATED:
/*
 I moved the image and the download method to a view model. I was trying to make the image reload when it finished downloading
 But still, it doesn't load. I tried published Data instead of UIImage, still doesn't work
 */

import Foundation
import SwiftUI

@MainActor
struct AsyncCachedImage<ImageView: View, PlaceholderView: View>: View {
    // Input dependencies
    var url: URL?
    @ViewBuilder var content: (Image) -> ImageView
    @ViewBuilder var placeholder: () -> PlaceholderView

    // Downloaded image
    @StateObject private var viewModel = CacheImageViewModel()

    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> ImageView,
        @ViewBuilder placeholder: @escaping () -> PlaceholderView
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }

    var body: some View {
        VStack {
            if let imageData = viewModel.imageData, let uiImage = UIImage(data: imageData) {
                content(Image(uiImage: uiImage))
            } else {
                placeholder()
                    .onAppear {
                        Task {
                            await viewModel.downloadPhoto(url: url)
                        }
                    }
            }
        }
    }
}

class CacheImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var imageData: Data?

    // Downloads if the image is not cached already
    // Otherwise returns from the cache
    func downloadPhoto(url: URL?) async {
        do {
            guard let url else { return }

            // Check if the image is cached already
            if let cachedResponse = URLCache.shared.cachedResponse(for: .init(url: url)) {
                imageData = cachedResponse.data
                // image = UIImage(data: cachedResponse.data)
            } else {
                let (data, response) = try await URLSession.shared.data(from: url)

                // Save returned image data into the cache
                URLCache.shared.storeCachedResponse(.init(response: response, data: data), for: .init(url: url))
                imageData = data

                // guard let image = UIImage(data: data) else {
                //     return
                // }
                // self.image = image
            }
        } catch {
            print("Error downloading: \(error)")
            return
        }
    }
}
