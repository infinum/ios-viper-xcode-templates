//
//  Viper_DemoApp.swift
//  Viper-Demo
//
//  Created by Hrvoje Hrvoić on 2025-09-03.
//

import SwiftUI

/// Login View
/// The main login interface allowing users to sign in or register
struct LoginView: View {
    
    @StateObject var presenter: LoginPresenter
    @FocusState private var focusedField: Field?
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            LogoSectionView()
            
            VStack(alignment: .leading, spacing: 0) {
                LoginTitleView()
                SubtitleView()
                EmailFieldView(
                    email: $presenter.email,
                    focusedField: $focusedField
                )
                PasswordFieldView(
                    password: $presenter.password,
                    isSecureTextEntry: presenter.isSecureTextEntry,
                    areActionsEnabled: presenter.areActionsEnabled,
                    focusedField: $focusedField,
                    onToggleSecureEntry: presenter.toggleSecureTextEntry,
                    onLogin: presenter.login
                )
                RememberMeView(
                    isRememberMeEnabled: presenter.isRememberMeEnabled,
                    onToggle: presenter.toggleRememberMe
                )
                LoginButtonView(
                    areActionsEnabled: presenter.areActionsEnabled,
                    focusedField: $focusedField,
                    onLogin: presenter.login
                )
                RegisterButtonView(
                    areActionsEnabled: presenter.areActionsEnabled,
                    focusedField: $focusedField,
                    onRegister: presenter.register
                )
            }
            
            Spacer()
        }
        .background(
            Image("background")
                .resizable()
                .ignoresSafeArea()
        )
        .alert("Error", isPresented: .constant(presenter.errorMessage != nil)) {
            Button("OK") {
                presenter.clearError()
            }
        } message: {
            if let errorMessage = presenter.errorMessage {
                Text(errorMessage)
            }
        }
        .overlay {
            if presenter.isLoading {
                LoadingOverlayView()
            }
        }
    }
}

// MARK: - Focus Field Enum

extension LoginView {
    enum Field: Hashable {
        case email
        case password
    }
}

// MARK: - Logo Section View

private struct LogoSectionView: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 120)
            
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 147, height: 38.5)
            
            Spacer()
                .frame(height: 30)
        }
    }
}

// MARK: - Login Title View

private struct LoginTitleView: View {
    var body: some View {
        HStack {
            Text("Login")
                .font(.init(UIFont.sfProFont(ofSize: 34, weight: .bold)))
                .foregroundColor(.white)
                .padding(.leading, 20)
            
            Spacer()
        }
        .padding(.bottom, 20)
    }
}

// MARK: - Subtitle View

private struct SubtitleView: View {
    var body: some View {
        HStack {
            Text("In order to continue please log in.")
                .font(.init(UIFont.sfProFont(ofSize: 17, weight: .regular)))
                .foregroundColor(.white)
                .padding(.leading, 24)
            
            Spacer()
        }
        .padding(.bottom, 45)
    }
}

// MARK: - Email Field View

private struct EmailFieldView: View {
    
    @Binding var email: String
    @FocusState.Binding var focusedField: LoginView.Field?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("Email", text: $email)
                    .font(.init(UIFont.sfProFont(ofSize: 17, weight: .regular)))
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .focused($focusedField, equals: .email)
                    .onSubmit {
                        focusedField = .password
                    }
                    .padding(.leading, 36)
                    .padding(.trailing, 36)
                
                Spacer()
            }
            .frame(height: 22)
            .padding(.bottom, 13)
            
            Rectangle()
                .fill(Color.white)
                .frame(height: 1)
                .padding(.horizontal, 20)
        }
        .padding(.bottom, 26)
    }
}

// MARK: - Password Field View

private struct PasswordFieldView: View {
    
    @Binding var password: String
    let isSecureTextEntry: Bool
    let areActionsEnabled: Bool
    @FocusState.Binding var focusedField: LoginView.Field?
    let onToggleSecureEntry: () -> Void
    let onLogin: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Group {
                    if isSecureTextEntry {
                        SecureField("Password", text: $password)
                    } else {
                        TextField("Password", text: $password)
                    }
                }
                .font(.init(UIFont.sfProFont(ofSize: 17, weight: .regular)))
                .foregroundColor(.white)
                .textContentType(.password)
                .focused($focusedField, equals: .password)
                .onSubmit {
                    if areActionsEnabled {
                        onLogin()
                    }
                }
                .padding(.leading, 36)
                
                Spacer()
                    .frame(width: 2)
                
                Button {
                    onToggleSecureEntry()
                } label: {
                    Image(isSecureTextEntry ? "show_password" : "hide_password")
                        .frame(width: 24, height: 24)
                }
                .padding(.trailing, 32)
            }
            .frame(height: 21)
            .padding(.bottom, 14)
            
            Rectangle()
                .fill(Color.white)
                .frame(height: 1)
                .padding(.horizontal, 20)
        }
        .padding(.bottom, 19)
    }
}

// MARK: - Remember Me View

private struct RememberMeView: View {
    
    let isRememberMeEnabled: Bool
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 5) {
            Button {
                onToggle()
            } label: {
                Image(isRememberMeEnabled ? "checkbox_checked" : "checkbox_unchecked")
                    .frame(width: 24, height: 24)
            }
            .padding(.leading, 27)
            
            Text("Remember me")
                .font(.init(UIFont.sfProFont(ofSize: 17, weight: .regular)))
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.bottom, 30)
    }
}

// MARK: - Login Button View

private struct LoginButtonView: View {
    
    let areActionsEnabled: Bool
    @FocusState.Binding var focusedField: LoginView.Field?
    let onLogin: () -> Void
    
    var body: some View {
        Button {
            focusedField = nil
            onLogin()
        } label: {
            Text("Login")
                .font(.init(UIFont.sfProFont(ofSize: 17, weight: .semibold)))
                .foregroundColor(Color(red: 0.321, green: 0.212, blue: 0.549))
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(
                    areActionsEnabled ? Color.white : Color.white.opacity(0.3)
                )
                .cornerRadius(24)
        }
        .disabled(!areActionsEnabled)
        .opacity(areActionsEnabled ? 1.0 : 0.3)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

// MARK: - Register Button View

private struct RegisterButtonView: View {
    
    let areActionsEnabled: Bool
    @FocusState.Binding var focusedField: LoginView.Field?
    let onRegister: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            
            Button {
                focusedField = nil
                onRegister()
            } label: {
                Text("Register")
                    .font(.init(UIFont.sfProFont(ofSize: 17, weight: .bold)))
                    .foregroundColor(.white)
            }
            .disabled(!areActionsEnabled)
            .opacity(areActionsEnabled ? 1.0 : 0.698)
            
            Spacer()
        }
        .padding(.bottom, 32)
    }
}
// MARK: - SwiftUI Previews

#Preview("Default State") {
    LoginView(presenter: LoginPresenter(
        interactor: LoginInteractor(),
        wireframe: LoginWireframe(navigationPath: .constant(NavigationPath()))
    ))
}

#Preview("Loading State") {
    LoginView(presenter: {
        let presenter = LoginPresenter(
            interactor: LoginInteractor(),
            wireframe: LoginWireframe(navigationPath: .constant(NavigationPath()))
        )
        presenter.email = "test@example.com"
        presenter.password = "password123"
        presenter.isLoading = true
        return presenter
    }())
}

#Preview("Error State") {
    LoginView(presenter: {
        let presenter = LoginPresenter(
            interactor: LoginInteractor(),
            wireframe: LoginWireframe(navigationPath: .constant(NavigationPath()))
        )
        presenter.email = "test@example.com"
        presenter.password = "password123"
        presenter.errorMessage = "Invalid credentials. Please try again."
        return presenter
    }())
}
