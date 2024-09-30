//
//  AddFriendView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/30/24.
//

import CachedAsyncImage
import SwiftUI

struct AddFriendView: View {
    @StateObject private var addFriendVM = AddFriendViewModel()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            Form {
                ForEach(addFriendVM.searchResults) { user in
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

                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.com_regular)

                            Text(user.userName)
                                .font(.com_caption)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        // Image(systemName: "person.badge.clock")
                        if !addFriendVM.isFriend(user) {
                            if addFriendVM.didSendRequestTo(user) {
                                Button {
                                    // TODO: Remove request when clicked
                                } label: {
                                    // Image(systemName: "person.crop.circle.badge.questionmark")
                                    //     .resizable()
                                    //     .scaledToFit()
                                    Text("Pending")
                                        .font(.com_subheadline)
                                }
                                .frame(height: 30)
                            } else if addFriendVM.didReceiveRequestFrom(user) {
                                Button {
                                    addFriendVM.addFriend(user)
                                } label: {
                                    Text("Accept")
                                        .font(.com_subheadline)
                                }
                                .frame(height: 30)
                            } else {
                                Button {
                                    addFriendVM.addFriend(user)
                                } label: {
                                    // Image(systemName: "person.crop.circle.badge.plus")
                                    //     .resizable()
                                    //     .scaledToFit()
                                    Text("Add")
                                        .font(.com_subheadline)
                                }
                                .frame(height: 30)
                            }
                        } else {
                            Image(systemName: "person.fill.checkmark")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 25)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .searchable(text: $addFriendVM.searchText)
        .disableAutocorrection(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}
