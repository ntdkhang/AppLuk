//
//  SavedKnowledgeListView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/29/24.
//

import SwiftUI

struct SavedKnowledgeListView: View {
    @ObservedObject var dataStorageManager = DataStorageManager.shared
    @State private var showComments = false
    // @State private var knowledgeId = ""
    @State private var currentKnowledge = Knowledge.empty
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(dataStorageManager.savedKnowledges) { knowledge in
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
                CommentsView(commentsVM: CommentsViewModel(knowledge: self.currentKnowledge))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
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
            ToolbarItem(placement: .principal) {
                Text("Saved Knowledge")
                    .font(.com_title3)
            }
        }
    }
}
