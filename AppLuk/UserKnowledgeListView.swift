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
    private var titleString: String = ""
    @Environment(\.dismiss) var dismiss

    init(userId: String) {
        _userKnowledgeVM = StateObject(wrappedValue: UserKnowledgeViewModel(userId: userId))
        if userId == DataStorageManager.shared.currentUserId {
            titleString = "Your Knowledge"
        } else {
            titleString = "Friend's Knowledge"
        }
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
            // ToolbarItem(placement: .topBarTrailing) {
            //     Button {
            //         isShowingUnfriendDialog = true
            //     } label: {
            //         // Image(systemName: "person.crop.circle.badge.questionmark")
            //         //     .resizable()
            //         //     .scaledToFit()
            //         Image(systemName: "person.fill.xmark")
            //             .resizable()
            //             .scaledToFit()
            //             .frame(height: 20)
            //             .foregroundColor(.dangerButton)
            //     }
            //     .confirmationDialog(
            //         "Remove this person from your friend list?",
            //         isPresented: $isShowingUnfriendDialog
            //     ) {
            //         Button("Remove", role: .destructive) {
            //             DataStorageManager.shared.removeFriend(userId: userKnowledgeVM.userId)
            //         }
            //     } message: {
            //         Text("Remove this person from your friend list?")
            //     }
            // }
            ToolbarItem(placement: .principal) {
                Text(titleString)
                    .font(.com_regular)
            }
        }
    }
}
