//
//  SearchKnowledgeView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/29/24.
//

import SwiftUI

struct SearchKnowledgeView: View {
    @StateObject private var knowledgeVM = SearchKnowledgeViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showComments = false
    // @State private var knowledgeId = ""
    @State private var currentKnowledge: Knowledge? = Knowledge.empty
    @State private var searchString = ""
    let tags = Knowledge.tags
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(knowledgeVM.knowledges) { knowledge in
                        KnowledgeView(knowledge: knowledge, showComments: $showComments, currentKnowledge: $currentKnowledge)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .containerRelativeFrame(.vertical)
                    }
                }
                .padding(.top, 32)
            }
            .ignoresSafeArea()
            .scrollTargetLayout()
            .scrollTargetBehavior(.paging)
            .scrollBounceBehavior(.basedOnSize)
            .onChange(of: currentKnowledge) {} // IDK why but if I remove this, it crashes when open comments. Maybe it needs to reload when the value of knowledgeId changed
            .sheet(isPresented: $showComments) {
                CommentsView(commentsVM: CommentsViewModel(knowledge: self.currentKnowledge ?? .empty))
            }
        }
        .searchable(text: $searchString)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.background
        )
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    ForEach(tags, id: \.self) { tag in
                        Button {
                            knowledgeVM.selectedTag = tag
                        } label: {
                            Text(tag)
                                .font(.com_subheadline)
                                .foregroundColor(.white)
                        }
                    }
                } label: {
                    if knowledgeVM.selectedTag == "" {
                        Text("Topic")
                            .font(.com_regular)
                            .foregroundColor(.lightButton)
                    } else {
                        Text(knowledgeVM.selectedTag)
                            .font(.com_regular)
                            .foregroundColor(.lightButton)
                    }
                }

                // Picker("Choose Tag", selection: $knowledgeVM.selectedTag) {
                //     ForEach(tags, id: \.self) { tag in
                //         Text(tag)
                //             .tag(tag)
                //             .font(.com_subheadline)
                //             .foregroundColor(.white)
                //     }
                // }
            }
        }
    }
}
