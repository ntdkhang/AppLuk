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
    @State private var presentCreateView = false
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(dataStorageManager.knowledges) { knowledge in
                        KnowledgeView(knowledge: knowledge)
                            .containerRelativeFrame(.vertical)
                    }
                }
                .scrollTargetBehavior(.paging)
            }
            .background(Color.backgroundColor)
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
                    Button {
                        presentCreateView = true
                    } label: {
                        Image("hut_bong")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 35)
                    }
                    .accessibilityLabel("Create new knowledge")
                }
            }
            .navigationDestination(isPresented: $presentCreateView) {
                CreateKnowledgeView(isPresented: $presentCreateView)
            }
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
