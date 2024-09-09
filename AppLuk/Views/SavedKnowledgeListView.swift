//
//  SavedKnowledgeListView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/29/24.
//

import SwiftUI

struct SavedKnowledgeListView: View {
    // @ObservedObject private var dataStorageManager = DataStorageManager.shared
    @State private var showComments = false
    // @State private var knowledgeId = ""
    @State private var currentKnowledge: Knowledge?
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(DataStorageManager.shared.savedKnowledges) { knowledge in
                        KnowledgeView(knowledge: knowledge, showComments: $showComments, currentKnowledge: $currentKnowledge)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .containerRelativeFrame(.vertical)
                    }
                }
            }
            .ignoresSafeArea()
            .scrollTargetLayout()
            .scrollTargetBehavior(.paging)
            .onChange(of: currentKnowledge) {} // IDK why but if I remove this, it crashes when open comments. Maybe it needs to reload when the value of knowledgeId changed
            .sheet(isPresented: $showComments) {
                CommentsView(commentsVM: CommentsViewModel(knowledge: self.currentKnowledge ?? .empty))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Saved Knowledge")
                    .font(.com_title3)
            }
        }
    }
}
