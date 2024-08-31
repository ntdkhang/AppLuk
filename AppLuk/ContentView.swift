//
//  ContentView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 7/28/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                KnowledgeListView()

                VStack {
                    NavigationLink {
                        SearchKnowledgeView()
                    } label: {
                        Text("Search Knowledge")
                    }

                    NavigationLink {
                        AddFriendView()
                    } label: {
                        Text("Add fen")
                    }

                    NavigationLink {
                        MainProfileView()
                    } label: {
                        Text("Profile")
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
}
