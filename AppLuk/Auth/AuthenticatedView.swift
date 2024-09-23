//
//  AuthenticatedView.swift
//  BetterConversationPrototype
//
//  Created by Khang Nguyen on 4/5/24.
//

import SwiftUI

// see https://michael-ginn.medium.com/creating-optional-viewbuilder-parameters-in-swiftui-views-a0d4e3e1a0ae
extension AuthenticatedView where Unauthenticated == EmptyView {
    init(@ViewBuilder content: @escaping () -> Content) {
        unauthenticated = nil
        self.content = content
    }
}

struct AuthenticatedView<Content, Unauthenticated>: View where Content: View, Unauthenticated: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var presentingLoginScreen = false
    @State private var presentingProfileScreen = false

    var unauthenticated: Unauthenticated?
    @ViewBuilder var content: () -> Content

    public init(unauthenticated: Unauthenticated?, @ViewBuilder content: @escaping () -> Content) {
        self.unauthenticated = unauthenticated
        self.content = content
    }

    public init(@ViewBuilder unauthenticated: @escaping () -> Unauthenticated, @ViewBuilder content: @escaping () -> Content) {
        self.unauthenticated = unauthenticated()
        self.content = content
    }

    var body: some View {
        switch viewModel.authenticationState {
        case .unauthenticated, .authenticating:
            VStack {
                // if let unauthenticated {
                //     unauthenticated
                // } else {
                //     // TODO: Have logo app in here, while checking whether I'm logged in
                //     Text("You're not logged in.")
                // }
                // Button("Tap here to log in") {
                //     viewModel.reset()
                //     presentingLoginScreen.toggle()
                // }
                AuthenticationView()
                    .environmentObject(viewModel)
            }
        // .sheet(isPresented: $presentingLoginScreen) {
        // }
        case .authenticated:
            VStack {
                content()
            }
        }
    }
}
