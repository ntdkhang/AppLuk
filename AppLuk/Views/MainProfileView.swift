//
//  MainProfileView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/29/24.
//

import CachedAsyncImage
import FirebaseAuth
import PhotosUI
import SwiftUI

struct MainProfileView: View {
    @ObservedObject var dataStorageManager = DataStorageManager.shared
    @StateObject var viewModel = ProfileViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authVM: AuthenticationViewModel

    @State private var showEditNameSheet: Bool = false
    @State private var showDeleteAccountConfirmation: Bool = false

    var body: some View {
        Form {
            Section {
                CachedAsyncImage(url: dataStorageManager.currentUserAvatarUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                } placeholder: {
                    Color.gray
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
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

                // NavigationLink {
                //     Text("Work in progress")
                // } label: {
                //     makeRow(iconName: "plus.square.dashed", text: "How to add Widget")
                // }
            }
            .listRowBackground(Color.gray.opacity(0.2))

            Section(header: Text("Friends").font(.com_caption)) {
                NavigationLink {
                    AddFriendView()
                } label: {
                    makeRow(iconName: "person.badge.plus", text: "Add friend")
                }

                NavigationLink {
                    FriendListView()
                } label: {
                    makeRow(iconName: "person.2", text: "Friend list")
                }
            }
            .listRowBackground(Color.gray.opacity(0.2))

            Section(header: Text("Privacy & Security").font(.com_caption)) {
                // NavigationLink {
                //     Text("Work in progress")
                // } label: {
                //     makeRow(iconName: "lock.shield", text: "Privacy policy")
                // }
                //

                Button {
                    do {
                        try Auth.auth().signOut()
                    } catch {
                        print(error)
                    }

                } label: {
                    makeRow(iconName: "rectangle.portrait.and.arrow.right", text: "Sign out")
                }

                Button {
                    showDeleteAccountConfirmation.toggle()
                } label: {
                    makeRow(iconName: "trash", text: "Delete your account")
                }
            }
            .listRowBackground(Color.gray.opacity(0.2))
        }
        .sheet(isPresented: $showEditNameSheet) {
            UpdateProfileView(viewModel: viewModel)
                .presentationDetents([.medium])
        }
        .confirmationDialog(
            "Are you sure you want to permanently delete your account?",
            isPresented: $showDeleteAccountConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                Task {
                    await authVM.deleteAccount()
                }
            }
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
