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
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(knowledgeVM.knowledges) { knowledge in
                        KnowledgeView(knowledge: knowledge)
                            .frame(maxWidth: .infinity)
                            .containerRelativeFrame(.vertical, alignment: .center)
                    }
                }
            }
            .ignoresSafeArea()
            .scrollTargetLayout()
            .scrollTargetBehavior(.paging)
            .scrollBounceBehavior(.basedOnSize)
        }
        .frame(maxWidth: .infinity)
        .background(
            Color.background
        )
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Picker("Choose a tag", selection: $knowledgeVM.selectedTag) {
                    ForEach(tags, id: \.self) { tag in
                        Text(tag)
                    }
                }
                .pickerStyle(.menu)
            }
        }
    }
}
