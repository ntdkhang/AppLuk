//
//  ConversationsView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/16/24.
//

import SwiftUI

struct ConversationsView: View {
    @StateObject var conversationsVM = ConversationsViewModel()
    var body: some View {
        VStack {
            ForEach(conversationsVM.conversations) { conversation in
                NavigationLink {
                    ConversationView(conversationVM: ConversationViewModel(conversation: conversation))
                } label: {
                    Text(conversation.id ?? "nil")
                }
            }
        }
        .task {
            await conversationsVM.getConversations()
        }
    }

}
