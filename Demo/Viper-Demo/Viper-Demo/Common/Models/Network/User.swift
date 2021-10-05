//
//  User.swift
//  Viper-v4-Demo
//
//  Created by Zvonimir Medak on 05.10.2021..
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
