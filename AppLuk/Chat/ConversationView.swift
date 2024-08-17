//
//  ConversationView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/16/24.
//

import SwiftUI

struct ConversationView: View {
    @ObservedObject var conversationVM: ConversationViewModel
    @State private var currentText = ""
    @State var isPresenting = false
    @State var scroll = false // observe change to scroll to bottom. Will be toggle when press send button
    @Namespace var scrollID

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView([.vertical]) {
                    LazyVStack {
                        // ForEach(conversation.messages) {
                        //     ChatBubble(message: $0)
                        // }
                    }
                    .id(scrollID)
                    .onChange(of: scroll) {
                        proxy.scrollTo(scrollID, anchor: .bottom)
                    }
                }
                .defaultScrollAnchor(.bottom)
            }

            textFieldView
                .padding(4)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Button {
                    isPresenting.toggle()
                } label: {
                    /// partner name
                    HStack(alignment: .center) {
                        Text("WTF IS THIS")
//                        Text(conversation.partner)
                            .foregroundColor(.primary)
                        Text(">")
                            .padding(.leading, -4)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
//        .sheet(isPresented: $isPresenting) {
//            ProfileView(user: .Khang)
//        }
    }

    var textFieldView: some View {
        HStack {
            TextField("Type your message", text: $currentText, axis: .vertical)
                .padding(8)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.gray.opacity(0.5), lineWidth: 1)
                }
            if !currentText.isEmpty {
                Button {
                    withAnimation {
                        scroll.toggle()
                        // conversationsVM.sendMessage(currentText, to: $conversation)
                        currentText = ""
                    }
                } label: {
                    Image(systemName: "arrow.up.message.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.blue)
                }
                .frame(height: 30)
            }
        }
    }
}

struct ChatBubble: View {
    var message: Message
    var body: some View {
        if message.isSender {
//            ChatBubbleFromMe(message: message.text, imageName: message.sender.imageName)
        } else {
//            ChatBubbleFromThem(message: message.text, imageName: message.sender.imageName)
        }
    }
}

struct AvatarIconView: View {
    var imageUrl: String
    var body: some View {
        AsyncImage(url: URL(string: imageUrl), content: { image in
            image
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
        }, placeholder: {
            Color.gray
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
        })
    }
}

struct ChatBubbleFromMe: View {
    var message: String
    // var imageName: String
    var color: Color {
        .blue
    }

    var body: some View {
        HStack {
            HStack(alignment: .bottom) {
                HStack {
                    Text(message)
                        .fontWeight(.semibold)
                }
                .padding(12)
                .frame(alignment: .trailing)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(color)
                }
                .padding(.leading, 24)

                // VStack {
                //     AvatarIconView(imageName: imageName)
                //         .frame(width: 25)
                // }
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

struct ChatBubbleFromThem: View {
    var message: String
    // var imageName: String
    var color: Color {
        Color(red: 51 / 255, green: 52 / 255, blue: 53 / 255)
    }

    var body: some View {
        HStack {
            HStack(alignment: .bottom) {
                // VStack {
                //     AvatarIconView(imageName: imageName)
                //         .frame(width: 25)
                // }
                HStack {
                    Text(message)
                        .fontWeight(.semibold)
                }
                .padding(12)
                .frame(alignment: .leading)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(color)
                }
                .padding(.trailing, 24)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
