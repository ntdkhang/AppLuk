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
            // .frame(maxHeight: .infinity, alignment: .top)

            IdeaCreatorView(knowledge: knowledge)
                .frame(maxHeight: .infinity, alignment: .top)

            ZStack {
                AsyncImage(url: knowledge.images.first!) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                } placeholder: {
                    RoundedRectangle(cornerRadius: 30)
                }
            }
        }
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
