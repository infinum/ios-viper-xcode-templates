//
//  User.swift
//  Viper-Demo
//
//  Created by Zvonimir Medak on 05.10.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import Foundation

struct User: Codable {
    let email: String
    let id: String
    let imageUrl: String?
}

struct AuthResponse: Codable {
    let user: User
}
