//
//  AsyncCachedImage.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/23/24.
//  credit to: [https://stackoverflow.com/questions/69214543/how-can-i-add-caching-to-asyncimage/77956449#77956449//]

import Foundation
import SwiftUI

@MainActor
struct AsyncCachedImage<ImageView: View, PlaceholderView: View>: View {
    // Input dependencies
    var url: URL?
    @ViewBuilder var content: (Image) -> ImageView
    @ViewBuilder var placeholder: () -> PlaceholderView

    // Downloaded image
    @State var image: UIImage? = nil

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
            if let uiImage = image {
                content(Image(uiImage: uiImage))
            } else {
                placeholder()
                    .onAppear {
                        Task {
                            image = await downloadPhoto()
                        }
                    }
            }
        }
    }

    // Downloads if the image is not cached already
    // Otherwise returns from the cache
    private func downloadPhoto() async -> UIImage? {
        do {
            guard let url else { return nil }

            // Check if the image is cached already
            if let cachedResponse = URLCache.shared.cachedResponse(for: .init(url: url)) {
                return UIImage(data: cachedResponse.data)
            } else {
                let (data, response) = try await URLSession.shared.data(from: url)

                // Save returned image data into the cache
                URLCache.shared.storeCachedResponse(.init(response: response, data: data), for: .init(url: url))

                guard let image = UIImage(data: data) else {
                    return nil
                }

                return image
            }
        } catch {
            print("Error downloading: \(error)")
            return nil
        }
    }
}
