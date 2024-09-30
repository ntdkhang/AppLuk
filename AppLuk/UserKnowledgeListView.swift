//
//  UserKnowledgeListView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 9/30/24.
//

import SwiftUI

struct UserKnowledgeListView: View {
    @StateObject var userKnowledgeVM: UserKnowledgeViewModel
    @State private var showComments = false
    @State private var currentKnowledge: Knowledge? = Knowledge.empty
    @State private var isShowingUnfriendDialog = false
    @Environment(\.dismiss) var dismiss

    init(userId: String) {
        _userKnowledgeVM = StateObject(wrappedValue: UserKnowledgeViewModel(userId: userId))
    }

    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(userKnowledgeVM.knowledges) { knowledge in
                        KnowledgeView(knowledge: knowledge, showUserLink: false, showComments: $showComments, currentKnowledge: $currentKnowledge)
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
        .background(Color.background)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingUnfriendDialog = true
                } label: {
                    Text("Unfriend")
                        .font(.com_back_button)
                        .foregroundColor(.dangerButton)
                }
                .confirmationDialog(
                    "Remove this person from your friend list?",
                    isPresented: $isShowingUnfriendDialog
                ) {
                    Button("Remove", role: .destructive) {
                        DataStorageManager.shared.removeFriend(userId: userKnowledgeVM.userId)
                        dismiss()
                    }
                } message: {
                    Text("Remove this person from your friend list?")
                }
            }
        }
    }
}
