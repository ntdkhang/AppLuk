//
//  KnowledgeView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/10/24.
//

import SwiftUI

struct KnowledgeView: View {
    var knowledge: Knowledge = .example1
    var body: some View {
        VStack {
            PostedByView(knowledge: knowledge)

            ImageCarouselView(knowledge: knowledge)
                .frame(maxWidth: .infinity)
                .layoutPriority(1)
            // .frame(maxHeight: .infinity, alignment: .top)
        }
        .background(
            Color.knowledgeBackground

            // Color(red: 30 / 256, green: 30 / 256, blue: 30 / 256)
        )
    }
}

struct BottomBarView: View {
    var body: some View {
        HStack {
            NavigationLink(destination: CreateKnowledgeView()) {
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
                    .padding()
            }
        }
    }
}

struct PageView: View {
    var imageUrl: String?
    var pageContent: String

    var body: some View {
        ZStack {
            clippedImage
            Color(.black)
                .opacity(0.7)
            ScrollView(.vertical) {
                Text(pageContent)
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(16)
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }

    var clippedImage: some View {
        Color.clear
            .aspectRatio(1.0, contentMode: .fit)
            .overlay(
                AsyncImage(url: URL(string: imageUrl ?? "")) { image in
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

struct ImageCarouselView: View {
    @State private var scrollID: Int?
    var knowledge: Knowledge
    var body: some View {
        VStack {
            /// Images scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(knowledge.imageUrls.indices, id: \.self) { i in
                        VStack {
                            PageView(imageUrl: knowledge.imageUrls[i], pageContent: knowledge.contentPages[i])
                                .padding(4)
                        }
                        .containerRelativeFrame(.horizontal)
                        // .scrollTransition(.animated, axis: .horizontal) { content, phase in
                        //     content
                        //         .opacity(phase.isIdentity ? 1.0 : 0.6)
                        // }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $scrollID)
            .scrollTargetBehavior(.paging)

            /// Indicator bar
            // does this look better inside or outside of the image?
            IndicatorView(imageCount: knowledge.imageUrls.count, scrollID: scrollID)
        }
    }
}

struct IndicatorView: View {
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

struct PostedByView: View {
    var knowledge: Knowledge
    var body: some View {
        HStack {
            Image("DK_ava")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40)
                .clipShape(Circle())
            Text(DataStorageManager.shared.getFriendName(withId: knowledge.postedById))
                .bold()
            Text(knowledge.relativeTimeString)
        }
    }
}

#Preview {
    KnowledgeView()
}
