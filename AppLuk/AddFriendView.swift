//
//  AddFriendView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/30/24.
//

import SwiftUI

struct AddFriendView: View {
    @StateObject private var addFriendVM = AddFriendViewModel()
    var body: some View {
        VStack {
            Form {
                ForEach(addFriendVM.searchResults) { user in
                    HStack {
                        AsyncImage(url: user.avatarURL) { image in
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

                        if !addFriendVM.isFriend(user) {
                            Button {
                                addFriendVM.addFriend(user)
                            } label: {
                                Image(systemName: "person.crop.circle.badge.plus")
                                    .resizable()
                                    .scaledToFit()
                            }
                            .frame(height: 30)
                        } else {
                            Image(systemName: "person.fill.checkmark")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 25)
                        }
                    }
                }
            }
        }
        .searchable(text: $addFriendVM.searchText)
        .disableAutocorrection(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}
