//
//  Viper_DemoApp.swift
//  Viper-Demo
//
//  Created by Hrvoje Hrvoić on 2025-09-03.
//

import SwiftUI

/// Home Wireframe
/// Handles navigation and view creation for the Home module
struct HomeWireframe: View {

    // MARK: - Navigation Properties
    @Binding private var navigationPath: NavigationPath

    // MARK: - Initialization
    
    /// Initialize the wireframe with navigation path
    /// - Parameter navigationPath: Binding to the navigation path for navigation management
    init(navigationPath: Binding<NavigationPath>) {
        self._navigationPath = navigationPath
    }
    
    // MARK: - View Body
    
    var body: some View {
        HomeView(presenter: createPresenter())
    }
    
    // MARK: - View Factory Methods
    
    /// Create the presenter for Home module
    /// - Returns: Configured HomePresenter instance
    private func createPresenter() -> HomePresenter {
        let interactor = HomeInteractor()
        let presenter = HomePresenter(
            interactor: interactor,
            wireframe: self
        )
        return presenter
    }
}

// MARK: - HomeWireframeInterface Implementation

extension HomeWireframe: HomeWireframeInterface {
    
    func navigateToLogin() {
        // Navigate back to login by removing all items from navigation path
        navigationPath = NavigationPath()
    }
    
    func navigateToShowDetails(id: String) {
        // TODO: Implement navigation to ShowDetails when that module is refactored
        print("Navigate to show details with ID: \(id)")
    }
}
