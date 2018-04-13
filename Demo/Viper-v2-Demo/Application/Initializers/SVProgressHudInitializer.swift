//
//  SVProgressHudInitializer.swift
//  Pokedex
//
//  Created by Filip Beć on 27/04/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import UIKit
import SVProgressHUD

class SVProgressHudInitializer: Initializable {

    func performInitialization() {
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setDefaultStyle(.dark)
    }

}
