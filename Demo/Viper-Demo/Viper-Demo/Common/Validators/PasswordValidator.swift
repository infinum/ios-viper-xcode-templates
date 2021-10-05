//
//  PasswordValidator.swift
//  Viper-v4-Demo
//
//  Created by Zvonimir Medak on 05.10.2021..
//

import Foundation

class PasswordValidator: StringValidator {

    private let minLength: UInt

    init(minLength: UInt) {
        self.minLength = minLength
    }

    func isValid(_ value: String) -> Bool {
        if let length = UInt(exactly: value.count) {
            return length >= minLength
        }
        return false
    }
}
