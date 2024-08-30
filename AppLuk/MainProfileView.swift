//
//  MainProfileView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/29/24.
//

import SwiftUI

struct MainProfileView: View {
    var body: some View {
        VStack {
            AsyncCachedImage(url: DataStorageManager.shared.currentUserAvatarUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                // .clipShape(Circle())
            } placeholder: {
                Color.gray
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
                    .clipShape(Circle())
            }
            .accessibilityLabel("Avatar")

            Text(DataStorageManager.shared.currentUser?.name ?? "")
                .accessibilityHint("Name")
                .bold()
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    MainProfileView()
}
