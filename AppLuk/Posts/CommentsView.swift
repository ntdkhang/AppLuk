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
        VStack {
            ScrollView {
                ForEach(commentsVM.comments) { comment in
                    VStack {
                        CommentView(comment: comment)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Divider()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
            }

            textField
                .padding(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            commentsVM.getComments()
        }
    }

    var textField: some View {
        HStack {
            TextField("Write your thoughts here:", text: $currentComment, axis: .vertical)
                .font(.com_regular)
                .multilineTextAlignment(.leading)
                .padding()

            Button {
                commentsVM.postComment(text: currentComment)
                currentComment = ""

                // dismiss keyboard
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil,
                    from: nil,
                    for: nil
                )
            } label: {
                Image(systemName: "paperplane.fill")
            }
            .foregroundColor(.blue)
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .padding(.horizontal)
            .accessibilityLabel("Post comment")
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
                .accessibilityLabel("Avatar")

                Text(postedBy?.name ?? "")
                    .font(.com_regular)
                    .accessibilityHint("Name")

                Text("•")
                    .accessibility(hidden: true)

                Text(comment.relativeTimeString)
                    .font(.com_caption)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityElement(children: .combine)

            Text(comment.text)
                .font(.com_regular)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    var postedBy: User? {
        DataStorageManager.shared.user(withId: comment.postedById)
    }
}
