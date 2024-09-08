//
//  UpdateProfileView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 9/7/24.
//

import PhotosUI
import SwiftUI

struct UpdateProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var errorText: String = ""

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            TextField("Name", text: $viewModel.name)
            TextField("username", text: $viewModel.username)
            Text(errorText)
            Button {
                Task {
                    let result = await viewModel.saveName()
                    switch result {
                    case .success:
                        dismiss()
                    case .notAvailable:
                        errorText = "Username not available"
                    case let .other(error):
                        errorText = error
                    }
                }
            } label: {
                Text("Save")
            }
        }
        // .navigationBarBackButtonHidden()
        // .toolbar {
        //     ToolbarItem(placement: .topBarLeading) {
        //         Button {
        //             dismiss()
        //         } label: {
        //             HStack {
        //                 Image(systemName: "chevron.backward")
        //                 Text("Back")
        //                     .font(.com_subheadline)
        //             }
        //         }
        //         .foregroundColor(.white)
        //     }
        // }
    }
}
