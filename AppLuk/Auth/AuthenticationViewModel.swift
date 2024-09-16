//
//  AuthenticationViewModel.swift
//  BetterConversationPrototype
//
//  Created by Khang Nguyen on 4/5/24.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging
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

                    // let db = Firestore.firestore()
                    // db.collection("fcmTokens").document(DataStorageManager.shared.currentUserId).setData([
                    //     "token": DataStorageManager.shared.fcmToken,
                    // ])

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

            var userProfile = AppLuk.User(name: self.name, userName: self.userName, avatarUrl: "", friendsId: [], savesId: [])

            if let uiImage = self.image ?? UIImage(named: "empty_ava"),
               let imageData = uiImage.jpegData(compressionQuality: 0.6)
            {
                let storageRef = Storage.storage().reference().child("avatars/").child("\(result.user.uid).jpeg")
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpeg"
                storageRef.putData(imageData, metadata: metaData) { metaData, error in
                    if error != nil {
                        print("Error uploading avatar")
                        DataStorageManager.shared.createNewUser(id: result.user.uid, user: userProfile) { error in
                            completion(error)
                        }
                    } else { // upload successful
                        storageRef.downloadURL { url, error in
                            guard let url = url else {
                                print("Error downloading URL for avatar")
                                DataStorageManager.shared.createNewUser(id: result.user.uid, user: userProfile) { error in
                                    completion(error)
                                }
                                return
                            }
                            userProfile = AppLuk.User(name: self.name, userName: self.userName, avatarUrl: url.absoluteString, friendsId: [], savesId: [])
                            DataStorageManager.shared.createNewUser(id: result.user.uid, user: userProfile) { error in
                                completion(error)
                            }
                        }
                    }
                }
            } else {
                print("Not found asset empty_ava")
                DataStorageManager.shared.createNewUser(id: result.user.uid, user: userProfile) { error in
                    completion(error)
                }
                return
            }
        }
    }

    func signOut() {
        do {
            DataStorageManager.shared = DataStorageManager() // remove all data in cache
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
