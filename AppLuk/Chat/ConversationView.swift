//
//  ConversationView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/16/24.
//

import SwiftUI

struct ConversationView: View {
    @ObservedObject var conversationVM: ConversationViewModel

    var body: some View {
        VStack {
            ForEach(conversationVM.messages) { message in
                Text(message.text)
            }
        }
        .task {
            await conversationVM.getConversation()
        }
    }
}
