//
//  ContentView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 7/28/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var dataStorageManager = DataStorageManager.shared
    var body: some View {
        NavigationStack {
            ZStack {
                KnowledgeListView()
                VStack {
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
                            AsyncImage(url: dataStorageManager.currentUserAvatarUrl) { image in
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
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea()
            }
        }
        .background(Color.background)
    }
}
