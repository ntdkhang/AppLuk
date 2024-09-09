//
//  MainProfileView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/29/24.
//

import FirebaseAuth
import PhotosUI
import SwiftUI

struct MainProfileView: View {
    @ObservedObject var dataStorageManager = DataStorageManager.shared
    @StateObject var viewModel = ProfileViewModel()
    @Environment(\.dismiss) var dismiss

    @State private var showEditNameSheet: Bool = false

    var body: some View {
        Form {
            Section {
                AsyncImage(url: dataStorageManager.currentUserAvatarUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                } placeholder: {
                    Color.gray
                        .aspectRatio(contentMode: .fit)
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
                PhotosPicker(selection: $viewModel.selectedPhoto, matching: .images) {
                    makeRow(iconName: "person.crop.circle", text: "Edit profile image")
                }

                Button {
                    showEditNameSheet = true
                } label: {
                    makeRow(iconName: "tag", text: "Edit name")
                }

                NavigationLink {
                    SavedKnowledgeListView()
                    // Text("AYO")
                } label: {
                    makeRow(iconName: "list.bullet.clipboard", text: "Saved posts")
                }

                NavigationLink {
                    Text("Work in progress")
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
                    Text("Work in progress")
                } label: {
                    makeRow(iconName: "person.2", text: "Friend list")
                }
            }
            .listRowBackground(Color.gray.opacity(0.2))

            Section(header: Text("Privacy & Security").font(.com_caption)) {
                NavigationLink {
                    Text("Work in progress")
                } label: {
                    makeRow(iconName: "lock.shield", text: "Privacy policy")
                }

                NavigationLink {
                    Text("Work in progress")
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
        .sheet(isPresented: $showEditNameSheet) {
            UpdateProfileView(viewModel: viewModel)
                .presentationDetents([.medium])
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .scrollContentBackground(.hidden)
        .background(Color.background)
    }

    func makeRow(iconName: String, text: String) -> some View {
        HStack {
            makeIcon(name: iconName)
            Text(text)
                .font(.com_regular)
        }
        .foregroundColor(.white)
    }

    func makeIcon(name: String) -> some View {
        Image(systemName: name)
            .resizable()
            .scaledToFit()
            .frame(width: 15)
            .padding(.trailing, 4)
    }
}
