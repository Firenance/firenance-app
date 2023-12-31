//
//  PasswordCreationPage.swift
//
//
//  Created by Hien Tran on 02/12/2023.
//

import ComposableArchitecture
import CoreUI
import Networking
import SwiftUI

public struct PasswordCreationPage: View {
    @ObserveInjection var iO

    struct ViewState: Equatable {
        @BindingViewState var password: String
        var passwordValidationError: String?
        var accountCreationError: String?
        var accountCreationInProgress: Bool
        var accountCreationResult: LoginResponse?
    }

    let store: StoreOf<RegisterReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, RegisterReducer.Action>

    public init(store: StoreOf<RegisterReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: \.passwordCreationViewState)
    }

    public var body: some View {
        LoadingOverlay(loading: viewStore.accountCreationInProgress) {
            VStack(alignment: .leading) {
                DismissButton()
                Spacing(height: .size40)
                Text("Create your password").typography(.titleScreen)
                Spacing(height: .size32)
                FireSecureTextField(
                    title: "Choose a password",
                    text: viewStore.$password
                )
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocorrectionDisabled()

                Text(viewStore.passwordValidationError ?? "")
                    .font(.custom(FontFamily.Inter.regular, size: 10))
                    .foregroundColor(.coreui.sentimentNegative)

                Spacer()

                Text(viewStore.accountCreationError ?? "")
                    .typography(.bodyDefault)
                    .foregroundColor(.coreui.sentimentNegative)

                Button {
                    viewStore.send(.createUserButtonTapped)
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                }
                .fireButtonStyle()
                .disabled(viewStore.passwordValidationError != nil)
            }
            .padding()
            .navigationBarHidden(true)
        }
        .enableInjection()
    }
}

extension BindingViewStore<RegisterReducer.State> {
    var passwordCreationViewState: PasswordCreationPage.ViewState {
        // swiftformat:disable redundantSelf
        PasswordCreationPage.ViewState(
            password: self.$password,
            passwordValidationError: self.passwordValidationError,
            accountCreationError: self.accountCreationError,
            accountCreationInProgress: self.accountCreationInProgress,
            accountCreationResult: self.accountCreationResult
        )
        // swiftformat:enable redundantSelf
    }
}
