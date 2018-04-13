//
//  AlamofireInitializer.swift
//  Pokedex
//
//  Created by Filip Beć on 27/04/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireNetworkActivityIndicator

class AlamofireInitializer: Initializable {

    func performInitialization() {
        let networkActivityManager = NetworkActivityIndicatorManager.shared
        networkActivityManager.isEnabled = true
        networkActivityManager.startDelay = 0

        Alamofire.SessionManager.default.adapter = AuthorizationAdapter.shared
    }

}
