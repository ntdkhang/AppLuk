//
//  ContentView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 7/28/24.
//

import CachedAsyncImage
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var deepLinkVM: DeepLinkViewModel
    var body: some View {
        TabView(selection: $deepLinkVM.selectedTab) {
            NavigationStack {
                HomeView()
            }
            .tag(DeepLinkTab.home)
            .toolbar(.hidden, for: .tabBar)

            DeepLinkedKnowledgeView(deepLinkVM: deepLinkVM)
                // .environment(deeplinkVM)
                .tag(DeepLinkTab.comment)
                .toolbar(.hidden, for: .tabBar)

            NavigationStack {
                DeepLinkedAddFriendView(deepLinkVM: deepLinkVM)
            }
            .tag(DeepLinkTab.friendRequest)
            .toolbar(.hidden, for: .tabBar)
        }
        .toolbar(.hidden, for: .tabBar)
        .background(Color.background)
    }
}

struct HomeView: View {
    @ObservedObject var dataStorageManager = DataStorageManager.shared
    var body: some View {
        ZStack {
            KnowledgeListView()
            VStack {
                bottomTabView
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
        }
    }

    var bottomTabView: some View {
        HStack {
            NavigationLink {
                SearchKnowledgeView()
            } label: {
                Image.magnifier
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 60)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)

            NavigationLink {
                MainProfileView()
            } label: {
                CachedAsyncImage(url: dataStorageManager.currentUserAvatarUrl) { image in
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
                .frame(height: 40)
            }
            .frame(maxWidth: .infinity)

            NavigationLink {
                Text("Work in progress")
            } label: {
                Image.giftHeart
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 60)
                    .foregroundColor(.white)
                    .offset(x: 0, y: -5)
            }
            .frame(maxWidth: .infinity)
        }
        .background(Color.background)
        .padding(.bottom, 12)
        .ignoresSafeArea()
    }
}
