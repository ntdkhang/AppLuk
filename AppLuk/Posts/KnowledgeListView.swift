//
//  KnowledgeListView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/19/24.
//

import FirebaseAuth
import SwiftUI

struct KnowledgeListView: View {
    @ObservedObject var dataStorageManager = DataStorageManager.shared
    @State private var presentCreateView = false
    @State private var showComments = false
    // @State private var knowledgeId = ""
    @State private var currentKnowledge = Knowledge.empty
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(dataStorageManager.knowledges) { knowledge in
                        KnowledgeView(knowledge: knowledge, showComments: $showComments, currentKnowledge: $currentKnowledge)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .containerRelativeFrame(.vertical)
                    }
                }
            }
            .ignoresSafeArea()
            .scrollTargetLayout()
            .scrollTargetBehavior(.paging)
            .onChange(of: currentKnowledge) {} // IDK why but if I remove this, it crashes when open comments. Maybe it needs to reload when the value of knowledgeId changed
            .sheet(isPresented: $showComments) {
                CommentsView(commentsVM: CommentsViewModel(knowledge: self.currentKnowledge))
            }
        }
        .background(Color.background)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavigationLink {
                    SavedKnowledgeListView()
                } label: {
                    Image(systemName: "list.bullet.clipboard")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                        .foregroundColor(.white)
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
