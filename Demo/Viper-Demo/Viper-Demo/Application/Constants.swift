//
//  Constants.swift
//  Viper-Demo
//
//  Created by Zvonimir Medak on 05.10.2021..
//

import Foundation

enum Constants {

    enum API {
        static let base = URL(string: "https://tv-shows.infinum.academy")!
        static let login = base.appendingPathComponent("/users/sign_in")
        static let register = base.appendingPathComponent("/users")
        static let shows = base.appendingPathComponent("/shows")
        static let showDetails = base.appendingPathComponent("/shows/")
    }

    enum UserDefaults {
        static let remember = "rememberUser"
        static let token = "token"
        static let expiry = "expiry"
        static let client = "client"
        static let uid = "uid"
    }

    enum RequestInterceptor {
        static let uid = "uid"
        static let accessToken = "access-token"
        static let client = "client"
        static let accept = "accept"
        static let expiry = "expiry"
        static let tokenType = "token-type"
        static let acceptFormat = "application/json"
        static let bearer = "Bearer"
        static let contentType = "application/json"
    }

    enum Cell {
        static let reviewsTitleCell = "ReviewsTitleTableViewCell"
        static let noReviewsCell = "NoReviewsTableViewCell"
        static let addReviewCell = "AddReviewTableViewCell"
    }
}
