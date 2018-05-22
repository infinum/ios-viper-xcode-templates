//
//  JSONAPIObject.swift
//  Pokedex
//
//  Created by Filip Beć on 28/04/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import UIKit
import Japx

struct JSONAPIObject<T: Codable>: Codable {

    var data: T

}
