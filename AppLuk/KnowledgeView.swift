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
            TopBarView()

            IdeaCreatorView(knowledge: knowledge)

            ImageCarouselView(knowledge: knowledge)
                .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

struct PageView: View {
    var imageUrl: URL?
    var pageContent: String

    var body: some View {
        Color.clear
            .aspectRatio(1.0, contentMode: .fit)
            .overlay(
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(.gray)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

struct ImageCarouselView: View {
    var knowledge: Knowledge
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(knowledge.imageUrls.indices, id: \.self) { i in
                    VStack {
                        PageView(imageUrl: knowledge.imageUrls[i], pageContent: knowledge.contentPages[i])
                            .padding(4)
                    }
                    .containerRelativeFrame(.horizontal)
                    .scrollTransition(.animated, axis: .horizontal) { content, _ in
                        content
                    }
                }
            }
        }
        .scrollTargetBehavior(.paging)
    }
}

struct IdeaCreatorView: View {
    var knowledge: Knowledge
    var body: some View {
        HStack {
            Image("DK_ava")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40)
                .clipShape(Circle())
            Text(knowledge.postedBy.name)
                .bold()
            Text(knowledge.relativeTimeString)
        }
    }
}

struct TopBarView: View {
    var body: some View {
        HStack {
            Image(systemName: "line.3.horizontal.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40)
                .padding()

            Spacer()

            RoundedRectangle(cornerRadius: 30)
                .stroke()
                .overlay {
                    HStack {
                        Text("Everyone")
                            .padding()
                        Image(systemName: "chevron.down")
                    }
                }
                .frame(width: 150, height: 40)

            Spacer()

            Image(systemName: "bubble.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40)
                .padding()
        }
    }
}

#Preview {
    KnowledgeView()
}
