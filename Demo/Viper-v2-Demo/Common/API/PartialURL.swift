//
//  PartialURL.swift
//  Viper-v2-Demo
//
//  Created by Donik Vrsnak on 4/16/18.
//  Copyright © 2018 Infinum. All rights reserved.
//

import Foundation

struct PartialURL: Codable {

    let url: URL?

    init(from decoder: Decoder) throws {
        let urlString = try decoder.singleValueContainer().decode(String.self)
        let url = Constants.API.URLBase.appendingPathComponent(urlString)

        self.url = url
    }

}
