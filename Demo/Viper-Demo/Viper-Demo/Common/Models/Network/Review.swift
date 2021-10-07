//
//  Review.swift
//  Viper-Demo
//
//  Created by Zvonimir Medak on 07.10.2021..
//

import Foundation

struct Review: Codable {
    let id: String
    let comment: String
    let rating: Int
    let showId: Int
    let user: User
}

struct ReviewResponse: Codable {
    let reviews: [Review]
}
