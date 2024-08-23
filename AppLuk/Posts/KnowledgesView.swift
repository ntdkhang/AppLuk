//
//  KnowledgesView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/19/24.
//

import FirebaseAuth
import SwiftUI

struct KnowledgesView: View {
    @ObservedObject var dataStorageManager = DataStorageManager.shared
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(dataStorageManager.knowledges) { knowledge in
                        KnowledgeView(knowledge: knowledge)
                            .containerRelativeFrame(.vertical)
                    }
                }
                .scrollTargetBehavior(.paging)
                ReactionView()
            }
            .background(Color.knowledgeBackground)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        do {
                            try Auth.auth().signOut()
                        } catch {
                            print(error)
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        CreateKnowledgeView()
                    } label: {
                        // Image(systemName: "square.and.pencil")
                        Image("hut_bong")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40)
                    }
                }
            }
        }
        .task {
            await DataStorageManager.shared.fetchCurrentUser()
            dataStorageManager.getKnowledges()
        }
    }
}

struct ReactionView: View {
    private var reactionList: [String] = ["🍄", "🗿", "🤡", "🚨", "🚩"]
    var body: some View {
        HStack {
            ForEach(self.reactionList, id: \.self) { icon in
                Button {
                } label: {
                    Text(icon)
                        .font(.system(size: 30))
                }
                .padding(8)
            }
        }
    }
}
