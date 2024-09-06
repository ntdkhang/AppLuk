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
    @StateObject var commentsVM: CommentsViewModel
    @State private var currentComment: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
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
            .navigationBarTitle(commentsVM.knowledge.title)
        }
        .presentationBackground(Color.background)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            commentsVM.getComments()
        }
    }

    var textField: some View {
        HStack {
            TextField("Gift me your thoughts", text: $currentComment, axis: .vertical)
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
                Image.giftHeart
                    .resizable()
            }
            .foregroundColor(.white)
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .padding(.trailing, 4)
            .accessibilityLabel("Post comment")
        }
        .background {
            RoundedRectangle(cornerRadius: 20)
                .stroke()
        }
    }

    init(commentsVM: CommentsViewModel) {
        _commentsVM = StateObject(wrappedValue: commentsVM)

        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "Comfortaa-SemiBold", size: 20)!]
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: "Comfortaa-SemiBold", size: 17)!]
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
