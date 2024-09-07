//
//  UpdateProfileView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 9/7/24.
//

import PhotosUI
import SwiftUI

struct UpdateProfileView: View {
    @State var name: String
    @State var username: String
    @StateObject var viewModel = ProfileViewModel()

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            PhotosPicker(selection: $viewModel.selectedPhoto, matching: .images) {
                Group {
                    if let avatar = DataStorageManager.shared.avatar {
                        avatar
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                    } else {
                        Image.empty_ava
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                    }
                }
                .frame(width: 100, height: 100)
            }

            TextField("Name", text: $name)
            TextField("username", text: $username)
        }
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
        }
    }
}
