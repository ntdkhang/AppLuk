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
    @State private var friendToShow: User? = nil
    var body: some View {
        VStack {
            List {
                ForEach(dataStorageManager.friends) { user in
                    friendCell(user)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .navigationDestination(item: $friendToShow) { user in
            UserKnowledgeListView(userId: user.id ?? "")
        }
    }

    func friendCell(_ user: User) -> some View {
        HStack {
            Button {
                friendToShow = user
            } label: {
                HStack {
                    CachedAsyncImage(url: user.avatarURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)
                    } placeholder: {
                        Color.gray
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)
                    }
                    .frame(width: 40, height: 40)

                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.com_regular)

                        Text(user.userName)
                            .font(.com_caption)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .buttonStyle(.plain)

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
            .buttonStyle(.plain)
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

#Preview {
    FriendListView()
}
