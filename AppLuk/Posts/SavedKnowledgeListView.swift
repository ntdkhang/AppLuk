//
//  SavedKnowledgeListView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/29/24.
//

import SwiftUI

struct SavedKnowledgeListView: View {
    @ObservedObject var dataStorageManager = DataStorageManager.shared
    @Environment(\.dismiss) var dismiss
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
        .background(Color.background)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                            .font(.com_subheadline)
                    }
                }
                .foregroundColor(.white)
            }
            ToolbarItem(placement: .principal) {
                Text("Saved Knowledge")
                    .font(.com_title3)
            }
        }
    }
}
