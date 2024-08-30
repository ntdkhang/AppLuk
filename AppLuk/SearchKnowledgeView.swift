//
//  SearchKnowledgeView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/29/24.
//

import SwiftUI

struct SearchKnowledgeView: View {
    @StateObject private var knowledgeVM = SearchKnowledgeViewModel()
    let tags = ["Health", "Psychology", "Philosophy", "Science", "Math", "Life", "Relationship"]
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(knowledgeVM.knowledges) { knowledge in
                    KnowledgeView(knowledge: knowledge)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .containerRelativeFrame(.vertical)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .scrollTargetBehavior(.paging)
            .scrollBounceBehavior(.basedOnSize)
            .scrollTargetLayout()

            VStack {
                Picker("Choose a tag", selection: $knowledgeVM.selectedTag) {
                    ForEach(tags, id: \.self) { tag in
                        Text(tag)
                    }
                }
                .pickerStyle(.menu)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .background(
            Color.background
        )
    }
}
