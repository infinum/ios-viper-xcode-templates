//
//  EmailValidator.swift
//  Pokedex
//
//  Created by Filip Beć on 02/05/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import UIKit

class EmailValidator: StringValidator {

    func isValid(_ value: String) -> Bool {
        return (value.count > 3 && value.contains("@"))
    }

}
