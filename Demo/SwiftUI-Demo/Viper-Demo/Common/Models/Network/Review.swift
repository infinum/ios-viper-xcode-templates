//
//  Review.swift
//  Viper-Demo
//
//  Created by Zvonimir Medak on 07.10.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import Foundation

struct Review: Codable, Identifiable {
    
    let id: String
    let comment: String
    let rating: Int
    let showId: Int
    let user: User
}

struct ReviewResponse: Codable {
    let reviews: [Review]
}
