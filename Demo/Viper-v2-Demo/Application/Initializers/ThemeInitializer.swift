//
//  ThemeInitializer.swift
//  Pokedex
//
//  Created by Filip Beć on 27/04/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import UIKit

class ThemeInitializer: Initializable {

    func performInitialization() {
        UINavigationBar.appearance(whenContainedInInstancesOf: [PokedexNavigationController.self]).tintColor = .white
        UINavigationBar.appearance(whenContainedInInstancesOf: [PokedexNavigationController.self]).barTintColor = UIColor.pokedexBlue
        UINavigationBar.appearance(whenContainedInInstancesOf: [PokedexNavigationController.self]).titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }

}
