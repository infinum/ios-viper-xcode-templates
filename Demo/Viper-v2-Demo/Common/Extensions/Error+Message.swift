//
//  Error+Message.swift
//  Pokedex
//
//  Created by Filip Beć on 28/04/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import Foundation
import Alamofire

extension Error {

    var message: String? {
        if self is AFError {
            return "Unknown error"
        } else if let error = self as? APIError {
            return error.localizedDescription
        } else {
            return self.localizedDescription
        }
    }

}
