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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.background
        )
        .onAppear {
            knowledgeVM.selectedTag = tags[0]
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                            .font(.com_subheadline)
                    }
                }
                .foregroundColor(.white)
            }
            ToolbarItem(placement: .topBarTrailing) {
                // Picker("Choose a tag", selection: $knowledgeVM.selectedTag) {
                //     ForEach(tags, id: \.self) { tag in
                //         Text(tag)
                //             .font(.com_subheadline)
                //             .foregroundColor(.white)
                //     }
                // }
                // .font(.com_subheadline)
                // .foregroundColor(.white)
                // .pickerStyle(.menu)

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
                    Text(knowledgeVM.selectedTag)
                        .font(.com_regular)
                        .foregroundColor(.lightButton)
                }
            }
        }
    }
}
