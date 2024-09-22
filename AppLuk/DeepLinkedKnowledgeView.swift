//
//  DeepLinkedKnowledgeView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 9/22/24.
//

import SwiftUI

struct DeepLinkedKnowledgeView: View {
    @ObservedObject var deepLinkVM: DeepLinkViewModel

    @State private var presentCreateView = false
    @ObservedObject private var dataStorageManager = DataStorageManager.shared
    // @State private var knowledgeId = ""
    var body: some View {
        NavigationStack {
            VStack {
                if let knowledge = deepLinkVM.knowledge {
                    KnowledgeView(knowledge: knowledge, showComments: $deepLinkVM.showComments, currentKnowledge: $deepLinkVM.knowledge)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .containerRelativeFrame(.vertical)
                }
            }
            .ignoresSafeArea()
            // .onChange(of: currentKnowledge) {} // IDK why but if I remove this, it crashes when open comments. Maybe it needs to reload when the value of knowledgeId changed
            .sheet(isPresented: $deepLinkVM.showComments) {
                CommentsView(commentsVM: CommentsViewModel(knowledge: deepLinkVM.knowledge ?? .empty))
            }
            .background(Color.background)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
                            deepLinkVM.selectedTab = .home
                        }
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                                .font(.com_back_button)
                        }
                        .foregroundColor(.white)
                    }
                }
            }
        }
    }
}
