//
//  CommentView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/21/24.
//

import FirebaseFirestore
import SwiftUI

struct CommentView: View {
    var knowledgeId: String
    @StateObject var commentVM: CommentViewModel
    @State var currentComment: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ForEach(commentVM.comments) { comment in
                        Text(comment.text)
                            .padding()
                    }
                }
                TextField("Write your thoughts here:", text: $currentComment)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        commentVM.postComment(text: currentComment)
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
            commentVM.getComments()
        }
    }
}
