//
//  FriendListView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 9/15/24.
//

import CachedAsyncImage
import SwiftUI

struct FriendListView: View {
    @ObservedObject var dataStorageManager = DataStorageManager.shared
    @State private var isShowingUnfriendDialog = false
    var body: some View {
        VStack {
            Form {
                ForEach(dataStorageManager.friends) { user in
                    HStack {
                        CachedAsyncImage(url: user.avatarURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                                .clipShape(Circle())
                        } placeholder: {
                            Color.gray
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                                .clipShape(Circle())
                        }

                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.com_regular)

                            Text(user.userName)
                                .font(.com_caption)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Button {
                            isShowingUnfriendDialog = true
                        } label: {
                            // Image(systemName: "person.crop.circle.badge.questionmark")
                            //     .resizable()
                            //     .scaledToFit()
                            Text("Unfriend")
                                .font(.com_subheadline)
                                .foregroundColor(.dangerButton)
                        }
                        .frame(height: 30)
                        .confirmationDialog(
                            "Remove this person from your friend list?",
                            isPresented: $isShowingUnfriendDialog
                        ) {
                            Button("Remove", role: .destructive) {
                                dataStorageManager.removeFriend(user: user)
                            }
                        } message: {
                            Text("Remove this person from your friend list?")
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}

#Preview {
    FriendListView()
}
