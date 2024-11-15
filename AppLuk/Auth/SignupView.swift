//
//  SignupView.swift
//  BetterConversationPrototype
//
//  Created by Khang Nguyen on 4/5/24.
//

import Combine
import PhotosUI
import SwiftUI

private enum FocusableField: Hashable {
    case email
    case password
    case confirmPassword
}

struct SignupView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var showUELA: Bool = false
    @State private var agreeUELA: Bool = false
    @Environment(\.dismiss) var dismiss

    @FocusState private var focus: FocusableField?

    private func signUpWithEmailPassword() {
        viewModel.signUpWithEmailPassword { error in
            if error == nil {
                DataStorageManager.shared.fetchCurrentUser()
                dismiss()
            }
        }
    }

    var body: some View {
        VStack {
            Text("Sign up")
                .font(.com_title2)
                .frame(maxWidth: .infinity, alignment: .leading)

            PhotosPicker(selection: $viewModel.selectedPhoto, matching: .images) {
                if viewModel.image == nil {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150, alignment: .center)
                        .clipShape(Circle())
                        .foregroundColor(.gray)
                } else {
                    Image(uiImage: viewModel.image!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150, alignment: .center)
                        .clipShape(Circle())
                }
            }

            HStack {
                Image(systemName: "tag")
                TextField("Name", text: $viewModel.name)
                    .font(.com_regular)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .focused($focus, equals: .email)
                    .submitLabel(.next)
                    .onSubmit {
                        self.focus = .password
                    }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 4)

            HStack {
                Image(systemName: "at")
                TextField("Email", text: $viewModel.email)
                    .font(.com_regular)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .focused($focus, equals: .email)
                    .submitLabel(.next)
                    .onSubmit {
                        self.focus = .password
                    }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 4)

            HStack {
                Image(systemName: "lock")
                SecureField("Password", text: $viewModel.password)
                    .focused($focus, equals: .password)
                    .submitLabel(.next)
                    .onSubmit {
                        self.focus = .confirmPassword
                    }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 8)

            HStack {
                Image(systemName: "lock")
                SecureField("Confirm password", text: $viewModel.confirmPassword)
                    .focused($focus, equals: .confirmPassword)
                    .submitLabel(.go)
                    .onSubmit {
                        signUpWithEmailPassword()
                    }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 8)

            if !viewModel.errorMessage.isEmpty {
                VStack {
                    Text(viewModel.errorMessage)
                        .foregroundColor(Color(UIColor.systemRed))
                }
            }

            Button {
                showUELA.toggle()
            } label: {
                Text("Read our End User License Agreement before continuing")
                    .font(.com_regular)
                    .foregroundColor(Color.accentColor)
            }

            Button {
                signUpWithEmailPassword()
            } label: {
                if viewModel.authenticationState != .authenticating {
                    Text("Sign up")
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                }
            }
            .disabled(!viewModel.isValid || !agreeUELA)
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)

            HStack {
                Text("Already have an account?")
                Button(action: { viewModel.switchFlow() }) {
                    Text("Log in")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            }
            .padding([.top, .bottom], 50)
        }
        .listStyle(.plain)
        .padding()
        .sheet(isPresented: $showUELA) {
            UELAView(agreeUELA: $agreeUELA)
        }
    }
}

struct UELAView: View {
    @Binding var agreeUELA: Bool
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack {
                    Text(eula)
                        .font(.com_subheadline)
                        .padding()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            agreeUELA = false
                            dismiss()
                        } label: {
                            Text("Cancel")
                                .font(.com_back_button)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            agreeUELA = true
                            dismiss()
                        } label: {
                            Text("Agree")
                                .font(.com_back_button)
                        }
                    }
                }
            }
        }
    }

    private let eula: String =
        """
        This End User License Agreement ("Agreement") is a legally binding agreement between you ("User") and Khang Nguyen ("Developer"). By downloading, accessing, or using the Sowlmate iOS application ("Application"), you agree to comply with and be bound by the terms of this Agreement.

        1. Acceptance of Terms
        By accessing or using the Application, you confirm that you are at least 13 years old (or the minimum age required in your jurisdiction) and have the legal capacity to enter into this Agreement.

        2. Prohibited Conduct
        Users agree not to engage in the following behaviors while using the Application:
        - Uploading, sharing, or transmitting any content deemed objectionable, including but not limited to content that is offensive, abusive, harassing, violent, hateful, obscene, or discriminatory.
        - Abusing, harassing, or threatening other users.
        - Engaging in any activity that violates applicable laws or regulations.

        3. Objectionable Content Policy
        Sowlmate has a strict no-tolerance policy for objectionable content and abusive behavior.

        3.1 Filtering Objectionable Content
        The Application employs automated and manual content filtering measures to identify and prevent the dissemination of objectionable material.

        3.2 Flagging Objectionable Content
        Users may flag content they believe violates this Agreement by using the "Report Content" feature. Reports are reviewed promptly to ensure compliance.

        3.3 Blocking Abusive Users
        Users may block abusive individuals through the "Unfriend" function within the Application. Once blocked, the abusive user will no longer be able to interact with the reporting user.

        4. Developer Responsibilities
        4.1 Action on Objectionable Content Reports
        - The Developer will review all reports of objectionable content within 24 hours of submission.
        - Content found to violate this Agreement will be removed immediately.
        - Users who submit objectionable content will be ejected from the Application and have their accounts permanently banned.

        5. Termination
        The Developer reserves the right to terminate your access to the Application at its sole discretion if you breach this Agreement or engage in prohibited conduct.

        6. Disclaimer
        The Application is provided "as-is" without any warranties, express or implied. The Developer is not liable for user-generated content but is committed to addressing violations promptly as described above.

        7. Amendments
        The Developer reserves the right to modify this Agreement at any time. Changes will be communicated through updates to the Application. Continued use of the Application after changes constitutes acceptance of the revised Agreement.

        8. Contact Information
        For questions or concerns regarding this Agreement or to report violations, please contact us at:
        khang.nguyen.trd@gmail.com

        By using the Sowlmate Application, you acknowledge that you have read, understood, and agreed to this End User License Agreement.
        """
}
