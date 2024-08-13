//
//  CreateKnowledgeView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/12/24.
//

import SwiftUI

struct CreateKnowledgeView: View {
    @State var contentPages: [String] = [""]
    @State var imageUrls: [URL?] = [nil]
    var body: some View {
        VStack {
            CreateImageCarouselView(contentPages: $contentPages, imageUrls: imageUrls)
        }
        .navigationBarBackButtonHidden(true)
        .frame(maxHeight: .infinity, alignment: .top)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                } label: {
                    Text("Cancel")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                } label: {
                    Text("Post")
                }
            }
        }
        .simultaneousGesture(
            DragGesture().onChanged { _ in
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil,
                    from: nil,
                    for: nil
                )
            }
        )
    }
}

struct CreatePageView: View {
    var imageUrl: URL?
    @Binding var pageContent: String

    var body: some View {
        ZStack {
            clippedImage
            Color(.black)
                .opacity(0.7)
            TextField("Start typing here", text: $pageContent, axis: .vertical)
                .keyboardType(.alphabet)
                .disableAutocorrection(true)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(16)
            // Text(pageContent)
        }
        .aspectRatio(1.0, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }

    var clippedImage: some View {
        Color.clear
            .aspectRatio(1.0, contentMode: .fit)
            .overlay(
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

struct CreateImageCarouselView: View {
    @State private var scrollID: Int?
    @Binding var contentPages: [String]
    @State var imageUrls: [URL?] = []

    var body: some View {
        VStack {
            /// Images scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(imageUrls.indices, id: \.self) { i in
                        VStack {
                            CreatePageView(imageUrl: imageUrls[i], pageContent: $contentPages[i])
                                .padding(4)
                        }
                        .containerRelativeFrame(.horizontal)
                        .scrollTransition(.animated, axis: .horizontal) { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1.0 : 0.6)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $scrollID)
            .scrollTargetBehavior(.paging)

            /// Indicator bar
            // does this look better inside or outside of the image?
            IndicatorView(imageCount: imageUrls.count, scrollID: scrollID)
                .frame(alignment: .top)
        }
    }
}

struct CreateIndicatorView: View {
    let imageCount: Int
    let scrollID: Int?

    var body: some View {
        HStack {
            ForEach(0 ..< imageCount, id: \.self) { curIndex in
                let scrollIndex = scrollID ?? 0
                Image(systemName: "circle.fill")
                    .font(.system(size: 8))
                    .foregroundColor(scrollIndex == curIndex ? .white : Color(.systemGray6))
            }
        }
    }
}

#Preview {
    NavigationView {
        CreateKnowledgeView()
    }
}
