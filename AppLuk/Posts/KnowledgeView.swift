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

            KnowledgeMainContent(knowledge: knowledge)
                .padding(.horizontal, 8)

            SaveAndReactView(knowledge: knowledge, showComments: $showComments)
                .padding(.top, -8)

            // Button {
            //     showComments.toggle()
            // } label: {
            //     Image(systemName: "bubble.left.and.bubble.right")
            //         .resizable()
            //         .aspectRatio(contentMode: .fit)
            //         .frame(width: 40)
            // }
            // .foregroundColor(.white)
        }
        .background(
            Color.background
        )
        .sheet(isPresented: $showComments) {
            CommentsView(knowledgeId: knowledge.id ?? "", commentsVM: CommentsViewModel(knowledgeId: knowledge.id ?? ""))
        }
    }
}

struct KnowledgeMainContent: View {
    var knowledge: Knowledge

    var body: some View {
        VStack {
            ImageCarouselView(knowledge: knowledge)
                .padding(3)
                .frame(maxWidth: .infinity)
                .layoutPriority(1)

            Text(knowledge.title)
                .lineLimit(2)
                .foregroundColor(Color.darkText)
                .font(.com_title2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom)
                .accessibilityHint("Knowledge title")
        }
        .background(Color.imageBackground)
    }
}

struct SaveAndReactView: View {
    @ObservedObject var dataStorageManager = DataStorageManager.shared
    let knowledge: Knowledge
    @Binding var showComments: Bool
    var body: some View {
        HStack {
            Button {
                DataStorageManager.shared.saveKnowledge(knowledgeId: knowledge.id)
            } label: {
                if DataStorageManager.shared.isSavedKnowledge(knowledge: knowledge) {
                    Image(systemName: "bookmark.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .foregroundColor(.lightButton)
                } else {
                    Image(systemName: "bookmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .foregroundColor(.white)
                }
            }

            Spacer()

            // TODO: move show comment button somewhere else
            Button {
                showComments.toggle()
            } label: {
                Image(systemName: "bubble.left.and.bubble.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40)
            }
            .foregroundColor(.white)

            /*
             Button {
             } label: {
                 Image(systemName: "arrow.up")
                     .resizable()
                     .aspectRatio(contentMode: .fit)
                     .frame(width: 30)
             }
             .foregroundColor(.lightButton)

             Button {
             } label: {
                 Image(systemName: "arrow.down")
                     .resizable()
                     .aspectRatio(contentMode: .fit)
                     .frame(width: 30)
             }
             .foregroundColor(.lightButton)
             */
        }
        .padding()
    }
}

struct PostedByView: View {
    var knowledge: Knowledge
    var body: some View {
        VStack {
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
            .accessibilityLabel("Avatar")
            HStack(alignment: .firstTextBaseline) {
                Text(DataStorageManager.shared.getFriendName(withId: knowledge.postedById))
                    .font(.com_title3)

                Text(knowledge.relativeTimeString)
                    .font(.com_subheadline)
            }
        }
        .accessibilityElement(children: .combine)
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
            IndicatorView(imageCount: knowledge.imageUrls.count, scrollID: scrollID, isTag: !knowledge.tags.isEmpty)
                .accessibility(hidden: true)
        }
    }
}

struct PageView: View {
    var imageUrl: String?
    var pageContent: String

    var body: some View {
        ZStack {
            clippedImage
            Color.imageBlur
            ScrollView(.vertical) {
                Text(pageContent)
                    .font(.com_regular)
                    .lineSpacing(10)
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(16)
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
        // .clipShape(RoundedRectangle(cornerRadius: 30))
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
            .clipped()
        // .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

struct IndicatorView: View {
    let imageCount: Int
    let scrollID: Int?
    let isTag: Bool

    var body: some View {
        HStack {
            ForEach(0 ..< indexMax, id: \.self) { curIndex in
                let scrollIndex = scrollID ?? 0
                Image(systemName: "circle.fill")
                    .font(.system(size: 8))
                    .foregroundColor(scrollIndex == curIndex ? .background : .gray)
            }
        }
    }

    var indexMax: Int {
        isTag ? imageCount + 1 : imageCount
    }
}
