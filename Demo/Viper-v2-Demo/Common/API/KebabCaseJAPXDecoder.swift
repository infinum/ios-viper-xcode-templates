//
//  KebabCaseJAPXDecoder.swift
//  Viper-v2-Demo
//
//  Created by Donik Vrsnak on 4/16/18.
//  Copyright © 2018 Infinum. All rights reserved.
//

import Foundation
import Japx

extension JapxDecoder {

    static var kebabCaseDecoder: JapxDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromKebabCase
        return JapxDecoder(jsonDecoder: decoder)
    }

}
