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
    }

    enum UserDefaults {
        static let remember = "rememberUser"
    }
}
