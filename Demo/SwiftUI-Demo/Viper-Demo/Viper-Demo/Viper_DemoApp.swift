//
//  Viper_DemoApp.swift
//  Viper-Demo
//
//  Created by Hrvoje Hrvoić on 2025-09-03.
//

import SwiftUI

@main
struct Viper_DemoApp: App {

    @State var navigationPath = NavigationPath()
    var body: some Scene {
        WindowGroup {
            // TODO: Add some Root view that will hold navigation path (simulate removing of login view from path and only
            // logged in views (home, etc.) after log in)
            NavigationStack(path: $navigationPath) { // TODO: Where to store navigation stack, TODO2: environment examples
                LoginWireframe(navigationPath: $navigationPath)
            }
        }
    }
}
