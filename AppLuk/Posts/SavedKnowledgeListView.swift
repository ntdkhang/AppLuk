//
//  SavedKnowledgeListView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/29/24.
//

import SwiftUI

struct SavedKnowledgeListView: View {
    @ObservedObject var dataStorageManager = DataStorageManager.shared
    @State private var presentCreateView = false
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(dataStorageManager.savedKnowledges) { knowledge in
                    KnowledgeView(knowledge: knowledge)
                        .containerRelativeFrame(.vertical)
                }
            }
            .scrollTargetBehavior(.paging)
        }
        .navigationTitle("Saved Knowledge")
        .background(Color.background)
    }
}
