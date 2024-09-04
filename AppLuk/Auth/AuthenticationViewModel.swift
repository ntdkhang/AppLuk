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
                    print("AUTH CHANGED")
                    DataStorageManager.shared.currentUserId = user!.uid
                    DataStorageManager.shared.fetchCurrentUser()
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

    func signUpWithEmailPassword(completion: @escaping (Error?) -> Void) {
        authenticationState = .authenticating
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard let result = result else {
                print("Error signing up: \(error?.localizedDescription ?? "Error")")
                self.errorMessage = error?.localizedDescription ?? "Error"
                self.authenticationState = .unauthenticated
                completion(error)
                return
            }
            let userProfile = AppLuk.User(name: self.name, userName: self.userName, avatarUrl: "", friendsId: [], savesId: [])
            DataStorageManager.shared.createNewUser(id: result.user.uid, user: userProfile) { error in
                completion(error)
            }
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
