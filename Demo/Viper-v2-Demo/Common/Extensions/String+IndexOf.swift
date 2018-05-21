//
//  String+IndexOf.swift
//  Viper-v2-Demo
//
//  Created by Donik Vrsnak on 4/16/18.
//  Copyright © 2018 Infinum. All rights reserved.
//

import Foundation

extension String {
    func index(of string: String, from startPos: Index? = nil, options: CompareOptions = .literal) -> Index? {
        if let startPos = startPos {
            return range(of: string, options: options, range: startPos ..< endIndex)?.lowerBound
        } else {
            return range(of: string, options: options)?.lowerBound
        }
    }
}
