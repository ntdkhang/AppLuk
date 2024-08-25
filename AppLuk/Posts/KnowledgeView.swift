//
//  KnowledgeView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/10/24.
//

import SwiftUI

struct KnowledgeView: View {
    @State private var showComments = false
    var knowledge: Knowledge
    var body: some View {
        VStack {
            PostedByView(knowledge: knowledge)

            ImageCarouselView(knowledge: knowledge)
                .frame(maxWidth: .infinity)
                .layoutPriority(1)

            Button {
                showComments.toggle()
            } label: {
                Image(systemName: "text.bubble")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
            }
            // .frame(maxHeight: .infinity, alignment: .top)
        }
        .background(
            Color.knowledgeBackground
        )
        .sheet(isPresented: $showComments) {
            CommentsView(knowledgeId: knowledge.id ?? "", commentsVM: CommentsViewModel(knowledgeId: knowledge.id ?? ""))
        }
    }
}

struct PostedByView: View {
    var knowledge: Knowledge
    var body: some View {
        HStack {
            AsyncCachedImage(url: DataStorageManager.shared.getFriendAvatarUrl(withId: knowledge.postedById)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
                    .clipShape(Circle())
            } placeholder: {
                Color.gray
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
                    .clipShape(Circle())
            }
            Text(DataStorageManager.shared.getFriendName(withId: knowledge.postedById))
                .bold()
            Text(knowledge.relativeTimeString)
        }
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
                    ForEach(knowledge.imageUrlsWithTags.indices, id: \.self) { i in
                        VStack {
                            PageView(imageUrl: knowledge.imageUrlsWithTags[i], pageContent: knowledge.contentPagesWithTags[i])
                                .padding(4)
                        }
                        .containerRelativeFrame(.horizontal)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $scrollID)
            .scrollTargetBehavior(.paging)

            /// Indicator bar
            // does this look better inside or outside of the image?
            IndicatorView(imageCount: knowledge.imageUrls.count, scrollID: scrollID, isTag: !knowledge.tags.isEmpty)
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

struct IndicatorView: View {
    let imageCount: Int
    let scrollID: Int?
    let isTag: Bool

    var body: some View {
        HStack {
            ForEach(0 ..< imageCount, id: \.self) { curIndex in
                let scrollIndex = scrollID ?? 0
                Image(systemName: "circle.fill")
                    .font(.system(size: 8))
                    .foregroundColor(scrollIndex == curIndex ? .white : Color(.systemGray6))
            }
            if isTag {
                let scrollIndex = scrollID ?? 0
                Image(systemName: "circle.fill")
                    .font(.system(size: 8))
                    .foregroundColor(scrollIndex == imageCount ? .purple : .blue)
            }
        }
    }
}
