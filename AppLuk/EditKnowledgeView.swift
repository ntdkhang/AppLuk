//
//  EditKnowledgeView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 9/25/24.
//

import CachedAsyncImage
import SwiftUI

struct EditKnowledgeView: View {
    @StateObject var knowledgeVM: EditKnowledgeViewModel
    @State var disablePostButton = false
    @Environment(\.dismiss) private var dismiss
    // @Binding var isPresented: Bool
    let tags = ["Health", "Psychology", "Philosophy", "Science", "Math", "Life", "Relationship"]

    init(knowledge: Knowledge, isPresented: Binding<Bool>) {
        _knowledgeVM = StateObject(wrappedValue: EditKnowledgeViewModel(knowledge: knowledge))
        // _isPresented = isPresented
    }

    var body: some View {
        VStack {
            ScrollView {
                EditImageCarouselView(knowledgeVM: knowledgeVM)

                TextField("Your knowledge title here", text: $knowledgeVM.title)
                    .font(.com_title2)
                    .padding()
            }
        }
        // .frame(maxWidth: .infinity)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // prevent double clicking and posting twice
                    disablePostButton = true
                    knowledgeVM.edit {
                        dismiss()
                    }
                } label: {
                    Text("Edit")
                        .font(.com_subheadline)
                        .foregroundColor(disablePostButton ? .gray : .white)
                }
                .disabled(disablePostButton)
            }
        }
        .simultaneousGesture(
            DragGesture().onChanged { _ in
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil,
                    from: nil,
                    for: nil
                )
            }
        )
        .background(
            Color.background
        )
    }
}

struct EditPageView: View {
    let imageUrl: String?
    @Binding var pageContent: String

    var body: some View {
        ZStack {
            clippedImage
            Color.imageBlur
            TextField("Start typing here", text: $pageContent, axis: .vertical)
                .keyboardType(.alphabet)
                .font(.com_regular)
                .disableAutocorrection(true)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(16)
        }
        .aspectRatio(1.0, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }

    var clippedImage: some View {
        Color.clear
            .aspectRatio(1.0, contentMode: .fit)
            .overlay(
                CachedAsyncImage(url: URL(string: imageUrl ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray
                }
            )
            .clipped()
        // .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

struct EditImageCarouselView: View {
    @ObservedObject var knowledgeVM: EditKnowledgeViewModel

    var body: some View {
        VStack {
            /// Images scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(knowledgeVM.contentPages.indices, id: \.self) { i in
                        VStack {
                            EditPageView(imageUrl: knowledgeVM.knowledge.imageUrlsWithTags[i],
                                         pageContent: $knowledgeVM.contentPages[i])
                                .padding(4)
                        }
                        .containerRelativeFrame(.horizontal)
                        .scrollTransition(.animated, axis: .horizontal) { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1.0 : 0.6)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $knowledgeVM.scrollID)
            .scrollTargetBehavior(.paging)

            /// Indicator bar
            CreateIndicatorView(imageCount: knowledgeVM.contentPages.count, scrollID: knowledgeVM.scrollID, isTag: false)
                .frame(alignment: .top)
                .accessibility(hidden: true)
        }
        .onChange(of: knowledgeVM.pageCount) {
            withAnimation {
                knowledgeVM.scrollID = knowledgeVM.pageCount - 1

                // TODO: also move the focus of the text field to the new text field
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil,
                    from: nil,
                    for: nil
                )
            }
        }
    }
}

struct EditIndicatorView: View {
    let imageCount: Int
    let scrollID: Int?
    let isTag: Bool

    var body: some View {
        HStack {
            ForEach(0 ..< imageCount, id: \.self) { curIndex in
                let scrollIndex = scrollID ?? 0
                Image(systemName: "circle.fill")
                    .font(.system(size: 8))
                    .foregroundColor(scrollIndex == curIndex ? .white : Color(.systemGray6))
            }
            if isTag {
                let scrollIndex = scrollID ?? 0
                Image(systemName: "circle.fill")
                    .font(.system(size: 8))
                    .foregroundColor(scrollIndex == imageCount ? .purple : .blue)
            }
        }
    }
}
