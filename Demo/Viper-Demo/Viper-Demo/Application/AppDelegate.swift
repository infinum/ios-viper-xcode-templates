//
//  AppDelegate.swift
//  Viper-Demo
//
//  Created by Zvonimir Medak on 05.10.2021..
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let initialViewController = UINavigationController()

        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else {
            return false
        }

        if shouldShowHome {
            initialViewController.setRootWireframe(HomeWireframe())
        } else {
            initialViewController.setRootWireframe(LoginWireframe())
        }

        window.rootViewController = initialViewController
        window.makeKeyAndVisible()
        return true
    }
}

private extension AppDelegate {
    var shouldShowHome: Bool {
        UserDefaults.standard.bool(forKey: Constants.UserDefaults.remember)
    }
}

