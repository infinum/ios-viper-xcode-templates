//
//  Viper_DemoApp.swift
//  Viper-Demo
//
//  Created by Hrvoje Hrvoić on 2025-09-03.
//

import SwiftUI

/// Login Wireframe
/// Handles navigation and view creation for the Login module
struct LoginWireframe: View {

    // MARK: - Navigation Properties
    @Binding private var navigationPath: NavigationPath

    init(navigationPath: Binding<NavigationPath>) {
        self._navigationPath = navigationPath
    }

    // MARK: - Initialization
    
    // MARK: - View Body
    
    var body: some View {
        LoginView(presenter: createPresenter())
            .navigationDestination(for: LoginDestination.self) { screen in
                switch screen {
                case .home:
                    HomeWireframe(navigationPath: $navigationPath)
                }
            }
    }
    
    // MARK: - View Factory Methods
    
    /// Create the presenter for Login module
    /// - Returns: Configured LoginPresenter instance
    private func createPresenter() -> LoginPresenter {
        let interactor = LoginInteractor()
        let presenter = LoginPresenter(
            interactor: interactor,
            wireframe: self
        )
        return presenter
    }
}

// MARK: - LoginWireframeInterface Implementation

extension LoginWireframe: LoginWireframeInterface {
    
    func navigateToHome() {
        navigationPath.append(LoginDestination.home)
    }
}
