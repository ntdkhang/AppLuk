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
                            // TODO: Unfriend
                            dataStorageManager.removeFriend(user: user)
                        } label: {
                            // Image(systemName: "person.crop.circle.badge.questionmark")
                            //     .resizable()
                            //     .scaledToFit()
                            Text("Unfriend")
                                .font(.com_subheadline)
                        }
                        .frame(height: 30)
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
