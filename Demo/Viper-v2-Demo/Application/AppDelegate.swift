//
//  AppDelegate.swift
//  Pokedex
//
//  Created by Filip Beć on 27/04/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var initializers: [Initializable] = [
        AlamofireInitializer(),
        SVProgressHudInitializer(),
        ThemeInitializer()
    ]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initializers.forEach { $0.performInitialization() }

        let initialController = PokedexNavigationController()
        initialController.setRootWireframe(LoginWireframe())

        self.window = UIWindow(frame: UIScreen.main.bounds)

        self.window?.rootViewController = initialController
        self.window?.makeKeyAndVisible()

        return true
    }

}

