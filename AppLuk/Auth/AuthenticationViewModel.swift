//
//  AuthenticationViewModel.swift
//  BetterConversationPrototype
//
//  Created by Khang Nguyen on 4/5/24.
//

import FirebaseAuth
import FirebaseStorage
import Foundation
import PhotosUI
import SwiftUI

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationFlow {
    case login
    case signUp
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""

    @Published var flow: AuthenticationFlow = .login

    @Published var isValid = false
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage = ""
    @Published var user: FirebaseAuth.User?
    @Published var userName = ""
    @Published var name = ""
    @Published var image: UIImage?

    init() {
        registerAuthStateHandler()

        $flow
            .combineLatest($email, $password, $confirmPassword)
            .map { flow, email, password, confirmPassword in
                flow == .login
                    ? !(email.isEmpty || password.isEmpty)
                    : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            }
            .assign(to: &$isValid)
    }

    @Published var selectedPhoto: PhotosPickerItem? = nil {
        didSet {
            if let selectedPhoto {
                Task {
                    try await loadTransferable(from: selectedPhoto)
                }
            }
        }
    }

    func loadTransferable(from imageSelection: PhotosPickerItem?) async throws {
        do {
            if let data = try await imageSelection?.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    image = uiImage
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    private var authStateHandler: AuthStateDidChangeListenerHandle?

    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { _, user in
                if user != nil {
                    DataStorageManager.shared.currentUserId = user!.uid
                }
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.userName = user?.email ?? ""
            }
        }
    }

    func switchFlow() {
        flow = flow == .login ? .signUp : .login
        errorMessage = ""
    }

    private func wait() async {
        do {
            print("Wait")
            try await Task.sleep(nanoseconds: 1_000_000_000)
            print("Done")
        } catch {
            print(error.localizedDescription)
        }
    }

    func reset() {
        flow = .login
        email = ""
        password = ""
        confirmPassword = ""
    }
}

// MARK: - Email and Password Authentication

extension AuthenticationViewModel {
    func signInWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            return true
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }

    func signUpWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)

            let storageRef = Storage.storage().reference(withPath: "/avatars")

            guard let uiImage = image ?? UIImage(named: "empty_ava"),
                  let data = uiImage.jpegData(compressionQuality: 0.2)
            else {
                print("Error: Missing empty_ava asset")
                return false
            }
            let _ = try await storageRef.child("\(result.user.uid).jpg").putDataAsync(data)
            let urlString = try await storageRef.child("\(result.user.uid).jpg").downloadURL().absoluteString

            let userProfile = AppLuk.User(id: result.user.uid, name: name, userName: userName, avatarUrl: urlString, friendsId: [], savesId: [])

            // TODO: pass image for avatar
            DataStorageManager.shared.createNewUser(user: userProfile)
            return true
        } catch {
            print("Error signing up: \(error)")
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }

//    func deleteAccount() async -> Bool {
//        do {
//            try await user?.delete()
//            return true
//        } catch {
//            errorMessage = error.localizedDescription
//            return false
//        }
//    }
}
