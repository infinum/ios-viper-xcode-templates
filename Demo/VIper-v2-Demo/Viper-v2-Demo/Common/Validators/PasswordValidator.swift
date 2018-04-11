//
//  PasswordValidator.swift
//  Pokedex
//
//  Created by Filip Beć on 02/05/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import UIKit

class PasswordValidator: StringValidator {

    private let _minLength: UInt

    init(minLength: UInt) {
        _minLength = minLength
    }

    func isValid(_ value: String) -> Bool {
        if let length = UInt(exactly: value.count) {
            return (length >= _minLength)
        }
        return false
    }

}
