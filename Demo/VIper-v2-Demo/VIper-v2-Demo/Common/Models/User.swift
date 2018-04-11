//
//  User.swift
//  Pokedex
//
//  Created by Filip Beć on 28/04/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import UIKit
import Unbox

class User: JSONAPIModel {

    var id: String?
    var email: String
    var username: String
    var authToken: String

    required init(unboxer: Unboxer) throws {
        email = try unboxer.unbox(key: "email")
        username = try unboxer.unbox(key: "username")
        authToken = try unboxer.unbox(key: "auth-token")
    }

    var type: String {
        return "users"
    }

}

extension User {

    var authorizationHeader: String {
        return String(format: "Token token=%@, email=%@", authToken, email)
    }

}
