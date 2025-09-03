//
//  EmailValidator.swift
//  Viper-Demo
//
//  Created by Zvonimir Medak on 05.10.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import Foundation

class EmailValidator: StringValidator {
    func isValid(_ value: String) -> Bool {
        return value.count > 5 && value.contains("@") && value.contains(".")
    }
}
