//
//  CreateKnowledgeView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/12/24.
//

import PhotosUI
import SwiftUI

struct CreateKnowledgeView: View {
    @StateObject var knowledgeVM = CreateKnowledgeViewModel()
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool
    let tags = ["Health", "Psychology", "Philosophy", "Science", "Math", "Life", "Relationship"]

    var body: some View {
        VStack {
            TextField("Your knowledge title here", text: $knowledgeVM.title)
                .font(.title2)
                .padding()

            CreateImageCarouselView(knowledgeVM: knowledgeVM)
                .frame(maxWidth: .infinity)

            HStack {
                PhotosPicker(selection: $knowledgeVM.selectedItem, matching: .images) {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                }

                Button {
                    knowledgeVM.removeCurrentImage()
                } label: {
                    Image(systemName: "xmark.bin")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .padding(.horizontal)
                }
                .disabled(knowledgeVM.disableRemoveCurrentImage)
                .accessibilityLabel("Remove current image")

                Spacer()
                Button {
                    knowledgeVM.newPage()
                } label: {
                    Image(systemName: "plus.rectangle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                }
                .accessibilityLabel("Add new page")
            }
            .padding()

            // MultiSelectPickerView(allTags: tags, selectedItems: $knowledgeVM.tagsSelection)
        }
        .navigationBarBackButtonHidden(true)
        .frame(maxHeight: .infinity, alignment: .top)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    CreateTitleView(knowledgeVM: knowledgeVM, isPresented: $isPresented)
                } label: {
                    Text("Next")
                }
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
            Color.backgroundColor
        )
    }
}

struct MultiSelectPickerView: View {
    let allTags: [String]

    // Binding to the selected items we want to track
    @Binding var selectedItems: Set<String>

    var body: some View {
        List {
            ForEach(allTags, id: \.self) { item in
                Button(action: {
                    withAnimation {
                        if self.selectedItems.contains(item) {
                            // Previous comment: you may need to adapt this piece
                            self.selectedItems.remove(item)
                        } else {
                            self.selectedItems.insert(item)
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "checkmark")
                            .opacity(self.selectedItems.contains(item) ? 1.0 : 0.0)
                        Text(item)
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

struct CreateTitleView: View {
    @ObservedObject var knowledgeVM: CreateKnowledgeViewModel
    @Binding var isPresented: Bool

    let items = ["Health", "Psychology", "Philosophy", "Science", "Math", "Life", "Relationship"]

    var body: some View {
        VStack {
            List(items, id: \.self, selection: $knowledgeVM.tagsSelection) {
                Text("\($0)")
                    .listRowBackground(Color.backgroundColor)
            }
            .scrollContentBackground(.hidden)
            .environment(\.editMode, .constant(EditMode.active))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .navigationTitle("Choose tags")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        await knowledgeVM.create()
                        isPresented = false
                    }
                } label: {
                    Text("Post")
                }
            }
        }
        .background(
            Color.backgroundColor
        )
    }
}

struct CreatePageView: View {
    @Binding var image: UIImage?
    @Binding var pageContent: String

    var body: some View {
        ZStack {
            clippedImage
            Color(.black)
                .opacity(0.7)
            TextField("Start typing here", text: $pageContent, axis: .vertical)
                .keyboardType(.alphabet)
                .disableAutocorrection(true)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(16)
        }
        .aspectRatio(1.0, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }

    @ViewBuilder
    var backgroundImage: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            Color.gray
        }
    }

    var clippedImage: some View {
        Color.clear
            .aspectRatio(1.0, contentMode: .fit)
            .overlay(
                backgroundImage
            )
            .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

struct CreateImageCarouselView: View {
    @ObservedObject var knowledgeVM: CreateKnowledgeViewModel

    var body: some View {
        VStack {
            /// Images scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(knowledgeVM.imageUrls.indices, id: \.self) { i in
                        VStack {
                            CreatePageView(image: $knowledgeVM.images[i],
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
            IndicatorView(imageCount: knowledgeVM.imageUrls.count, scrollID: knowledgeVM.scrollID, isTag: false)
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

struct CreateIndicatorView: View {
    let imageCount: Int
    let scrollID: Int?

    var body: some View {
        HStack {
            ForEach(0 ..< imageCount, id: \.self) { curIndex in
                let scrollIndex = scrollID ?? 0
                Image(systemName: "circle.fill")
                    .font(.system(size: 8))
                    .foregroundColor(scrollIndex == curIndex ? .white : Color(.systemGray6))
            }
        }
    }
}
