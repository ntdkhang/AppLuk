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
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(dataStorageManager.knowledges) { knowledge in
                        KnowledgeView(knowledge: knowledge)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .containerRelativeFrame(.vertical)
                    }
                }
            }
            .ignoresSafeArea()
            .scrollTargetLayout()
            .scrollTargetBehavior(.paging)
            .scrollBounceBehavior(.basedOnSize)
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
