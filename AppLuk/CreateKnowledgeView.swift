//
//  CreateKnowledgeView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/12/24.
//

import PhotosUI
import SwiftUI

struct CreateKnowledgeView: View {
    @StateObject var knowledgeVM = KnowledgeViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            CreateImageCarouselView(knowledgeVM: knowledgeVM)
            HStack {
                PhotosPicker(selection: $knowledgeVM.selectedItem, matching: .images) {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                }

                Image(systemName: "xmark.bin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 30)
                    .padding(.horizontal)

                Button {
                    knowledgeVM.newPage()
                } label: {
                    Image(systemName: "plus.rectangle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
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
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                } label: {
                    Text("Post")
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
    }
}

struct CreatePageView: View {
    @Binding var image: Image?
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
            // Text(pageContent)
        }
        .aspectRatio(1.0, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }

    @ViewBuilder
    var backgroundImage: some View {
        if let image = image {
            image
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
    @ObservedObject var knowledgeVM: KnowledgeViewModel

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
            IndicatorView(imageCount: knowledgeVM.imageUrls.count, scrollID: knowledgeVM.scrollID)
                .frame(alignment: .top)
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

#Preview {
    NavigationView {
        CreateKnowledgeView()
    }
}
