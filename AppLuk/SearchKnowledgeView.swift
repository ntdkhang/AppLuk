//
//  SearchKnowledgeView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/29/24.
//

import SwiftUI

struct SearchKnowledgeView: View {
    @StateObject private var knowledgeVM = SearchKnowledgeViewModel()
    @Environment(\.dismiss) private var dismiss
    let tags = Knowledge.tags
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(knowledgeVM.knowledges) { knowledge in
                        KnowledgeView(knowledge: knowledge)
                            .frame(maxWidth: .infinity)
                            .containerRelativeFrame(.vertical, alignment: .center)
                    }
                }
            }
            .ignoresSafeArea()
            .scrollTargetLayout()
            .scrollTargetBehavior(.paging)
            .scrollBounceBehavior(.basedOnSize)
        }
        .frame(maxWidth: .infinity)
        .background(
            Color.background
        )
        .onAppear {
            knowledgeVM.selectedTag = tags[0]
        }
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
            ToolbarItem(placement: .topBarTrailing) {
                Picker("Choose a tag", selection: $knowledgeVM.selectedTag) {
                    ForEach(tags, id: \.self) { tag in
                        Text(tag)
                    }
                }
                .font(.com_subheadline)
                .foregroundColor(.white)
                .pickerStyle(.menu)
            }
        }
    }
}
