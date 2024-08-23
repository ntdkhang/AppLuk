//
//  CommentsView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/21/24.
//

import CachedAsyncImage
import FirebaseFirestore
import SwiftUI

struct CommentsView: View {
    var knowledgeId: String
    @StateObject var commentsVM: CommentsViewModel
    @State var currentComment: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ForEach(commentsVM.comments) { comment in

                        CommentView(comment: comment)
                            .padding()
                    }
                }
                TextField("Write your thoughts here:", text: $currentComment, axis: .vertical)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .background(in: RoundedRectangle(cornerRadius: 20))
                    .border(.black)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        commentsVM.postComment(text: currentComment)
                        // dismiss or not dismiss?
                        dismiss()
                    } label: {
                        Text("Comment")
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            commentsVM.getComments()
        }
    }
}

struct CommentView: View {
    var comment: Comment

    var body: some View {
        VStack {
            HStack {
                CachedAsyncImage(url: DataStorageManager.shared.friend(withId: comment.postedById)?.avatarURL) { image in
                    image
                        .resizable()
                        .clipShape(Circle())
                } placeholder: {
                    Color.gray
                        .clipShape(Circle())
                }
                .frame(width: 30, height: 30)
                Text(comment.text)
            }
        }
    }
}
