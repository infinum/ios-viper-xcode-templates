//
//  KeyDecodingStategy+kebabCase.swift
//  Viper-v2-Demo
//
//  Created by Donik Vrsnak on 4/16/18.
//  Copyright © 2018 Infinum. All rights reserved.
//

import Foundation

struct AnyCodingKey : CodingKey {

    var stringValue: String
    var intValue: Int?

    init(_ base: CodingKey) {
        self.init(stringValue: base.stringValue, intValue: base.intValue)
    }

    init(stringValue: String) {
        self.stringValue = stringValue
    }

    init(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }

    init(stringValue: String, intValue: Int?) {
        self.stringValue = stringValue
        self.intValue = intValue
    }
}

extension JSONDecoder.KeyDecodingStrategy {

    static var convertFromKebabCase : JSONDecoder.KeyDecodingStrategy {
        return .custom { codingKeys in

            var key = AnyCodingKey(codingKeys.last!)
            while let index = key.stringValue.index(of: "-") {
                let char = key.stringValue[key.stringValue.index(index, offsetBy: 1)]

                key.stringValue.replaceSubrange(
                    index ... key.stringValue.index(index, offsetBy: 1), with: String(char).uppercased()
                )
            }

            return key
        }
    }
}
