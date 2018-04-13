//
//  User.swift
//  Pokedex
//
//  Created by Filip Beć on 28/04/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import UIKit
import Japx

struct User: JapxCodable {
    var type: String
    
    var id: String
    var email: String
    var username: String
    var authToken: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case email
        case username
        case authToken = "auth-token"
    }

}

extension User {

    var authorizationHeader: String {
        return String(format: "Token token=%@, email=%@", authToken, email)
    }

}
