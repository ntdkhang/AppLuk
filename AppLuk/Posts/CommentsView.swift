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
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }
                }

                textField
                    .padding(8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            commentsVM.getComments()
        }
    }

    var textField: some View {
        HStack {
            TextField("Write your thoughts here:", text: $currentComment, axis: .vertical)
                .multilineTextAlignment(.leading)
                .padding()

            Button {
                commentsVM.postComment(text: currentComment)
                // dismiss or not dismiss?
                // dismiss()
            } label: {
                Image(systemName: "paperplane.fill")
            }
            .foregroundColor(.blue)
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .padding(.horizontal)
        }
        .background {
            RoundedRectangle(cornerRadius: 20)
                .stroke()
        }
    }
}

struct CommentView: View {
    var comment: Comment

    var body: some View {
        VStack {
            HStack {
                AsyncCachedImage(url: postedBy?.avatarURL) { image in
                    image
                        .resizable()
                        .clipShape(Circle())
                } placeholder: {
                    Color.gray
                        .clipShape(Circle())
                }
                .frame(width: 30, height: 30)

                Text(postedBy?.name ?? "")
                Text(comment.relativeTimeString)
            }

            Text(comment.text)
        }
    }

    var postedBy: User? {
        DataStorageManager.shared.user(withId: comment.postedById)
    }
}

struct ReplyBoxView: View {
    @ObservedObject var dataStorageManager = DataStorageManager.shared
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 30)
                .stroke()
                .overlay {
                    HStack {
                        AsyncCachedImage(url: dataStorageManager.currentUser?.avatarURL, content: { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                                .clipShape(Circle())
                        }, placeholder: {
                            Color.gray
                                .frame(width: 40)
                                .clipShape(Circle())

                        })
                        Text("Đúng nhận sai cãi ...")
                            .padding()
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 24)
                .frame(height: 60)
        }
        .foregroundColor(Color(.lightGray))
    }
}
