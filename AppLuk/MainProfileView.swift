//
//  MainProfileView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/29/24.
//

import FirebaseAuth
import SwiftUI

struct MainProfileView: View {
    @ObservedObject var dataStorageManager = DataStorageManager.shared
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Section {
                AsyncCachedImage(url: dataStorageManager.currentUserAvatarUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                } placeholder: {
                    Color.gray
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                        .clipShape(Circle())
                }
                .frame(height: 100)
                .padding()
                .accessibilityLabel("Avatar")

                Text(dataStorageManager.currentUser?.name ?? "")
                    .font(.com_title2)
                    .accessibilityHint("Name")

                Text(dataStorageManager.currentUser?.userName ?? "")
                    .font(.com_regular)
                    .accessibilityHint("Username")
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)

            Section(header: Text("General").font(.com_caption)) {
                NavigationLink {
                    Text("Sike")
                } label: {
                    makeRow(iconName: "person.crop.circle", text: "Edit profile image")
                }

                NavigationLink {
                    Text("Sike")
                } label: {
                    makeRow(iconName: "tag", text: "Edit name")
                }
                NavigationLink {
                    Text("Sike")
                } label: {
                    makeRow(iconName: "at", text: "Edit email")
                }
                NavigationLink {
                    Text("Sike")
                } label: {
                    makeRow(iconName: "plus.square.dashed", text: "How to add Widget")
                }
            }
            .listRowBackground(Color.gray.opacity(0.2))

            Section(header: Text("Friends").font(.com_caption)) {
                NavigationLink {
                    AddFriendView()
                } label: {
                    makeRow(iconName: "person.badge.plus", text: "Add friend")
                }

                NavigationLink {
                    Text("Sike")
                } label: {
                    makeRow(iconName: "person.2", text: "Friend list")
                }
            }
            .listRowBackground(Color.gray.opacity(0.2))

            Section(header: Text("Privacy & Security").font(.com_caption)) {
                NavigationLink {
                    Text("Sike")
                } label: {
                    makeRow(iconName: "lock.shield", text: "Privacy policy")
                }

                NavigationLink {
                    Text("Sike")
                } label: {
                    makeRow(iconName: "trash", text: "Delete your account")
                }

                Button {
                    do {
                        try Auth.auth().signOut()
                    } catch {
                        print(error)
                    }

                } label: {
                    makeRow(iconName: "rectangle.portrait.and.arrow.right", text: "Sign out")
                }
            }
            .listRowBackground(Color.gray.opacity(0.2))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .scrollContentBackground(.hidden)
        .background(Color.background)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                            .font(.com_regular_light)
                    }
                }
                .foregroundColor(.white)
            }
        }
    }

    func makeRow(iconName: String, text: String) -> some View {
        HStack {
            makeIcon(name: iconName)
            Text(text)
                .font(.com_regular)
        }
    }

    func makeIcon(name: String) -> some View {
        Image(systemName: name)
            .resizable()
            .scaledToFit()
            .frame(width: 15)
            .padding(.trailing, 4)
    }
}
