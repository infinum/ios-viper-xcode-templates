//
//  APIError.swift
//  Pokedex
//
//  Created by Filip Beć on 28/04/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import Foundation

enum APIError: Error {
    case message(String)

    var localizedDescription: String {
        switch self {
        case .message(let string):
            return string
        }
    }

}
