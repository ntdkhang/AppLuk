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
            CreateImageCarouselView(knowledgeVM: knowledgeVM)
                .frame(maxWidth: .infinity)

            HStack {
                PhotosPicker(selection: $knowledgeVM.selectedItem, matching: .images) {
                    Image.camera
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .foregroundColor(.lightButton)
                }

                Button {
                    knowledgeVM.removeCurrentImage()
                } label: {
                    // Image.attachment
                    Image(systemName: "pip.remove")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .padding(.horizontal)
                }
                .opacity(knowledgeVM.disableRemoveCurrentImage ? 0 : 1)
                .foregroundColor(.lightButton)
                .accessibilityLabel("Remove current image")

                Spacer()

                Button {
                    knowledgeVM.newPage()
                } label: {
                    Image.addPage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .foregroundColor(.lightButton)
                }
                .accessibilityLabel("Add new page")
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .frame(maxHeight: .infinity, alignment: .top)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .font(.com_subheadline)
                        .foregroundColor(.white)
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    CreateTitleView(knowledgeVM: knowledgeVM, isPresented: $isPresented)
                } label: {
                    Text("Next")
                        .font(.com_subheadline)
                        .foregroundColor(.white)
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
            Color.background
        )
    }
}

struct CreateTitleView: View {
    @ObservedObject var knowledgeVM: CreateKnowledgeViewModel
    @Binding var isPresented: Bool
    @Environment(\.dismiss) private var dismiss
    @State var disablePostButton = false

    let items = Knowledge.tags

    var body: some View {
        VStack {
            TextField("Your knowledge title here", text: $knowledgeVM.title)
                .font(.com_title2)
                .padding()
            List(items, id: \.self, selection: $knowledgeVM.tagsSelection) {
                Text("\($0)")
                    .font(.com_regular)
                    .listRowBackground(Color.background)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .environment(\.editMode, .constant(EditMode.active))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // prevent double clicking and posting twice
                    disablePostButton = true
                    knowledgeVM.create {
                        isPresented = false
                    }
                } label: {
                    Text("Post")
                        .font(.com_subheadline)
                        .foregroundColor(disablePostButton ? .gray : .white)
                }
                .disabled(disablePostButton)
            }
        }
        .background(
            Color.background
        )
    }
}

struct CreatePageView: View {
    @Binding var image: UIImage?
    @Binding var pageContent: String

    var body: some View {
        ZStack {
            clippedImage
            Color.imageBlur
            TextField("Start typing here", text: $pageContent, axis: .vertical)
                // .keyboardType(.alphabet)
                .font(.com_regular)
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
            CreateIndicatorView(imageCount: knowledgeVM.imageUrls.count, scrollID: knowledgeVM.scrollID, isTag: false)
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
