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
                .font(.com_regular)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke()
                }

            TextField("username", text: $viewModel.username)
                .font(.com_regular)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke()
                }

            Text(errorText)
                .font(.com_subheadline)
                .foregroundColor(.red)

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
                    .font(.com_title3)
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal, 24)
                    .background {
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(Color.lightButton)
                    }
            }
        }
        .padding()
        .frame(maxHeight: .infinity)
        .background(Color.background)
    }
}
