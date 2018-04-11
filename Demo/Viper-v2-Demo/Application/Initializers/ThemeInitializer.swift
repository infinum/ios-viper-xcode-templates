//
//  ThemeInitializer.swift
//  Pokedex
//
//  Created by Filip Beć on 27/04/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import UIKit

class ThemeInitializer: NSObject, Initializable {

    @objc func performInitialization() {
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor.pokedexBlue
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
    }

}
