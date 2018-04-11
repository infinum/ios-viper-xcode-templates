//
//  JSONAPIObject.swift
//  Pokedex
//
//  Created by Filip Beć on 28/04/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import UIKit
import Unbox

protocol JSONAPIModel: Unboxable {
    var type: String { get }
    var id: String? { get set }
}

class JSONAPIObject<T: JSONAPIModel>: Unboxable {

    var object: T

    init(object: T) {
        self.object = object
    }

    required init(unboxer: Unboxer) throws {
        self.object = try unboxer.unbox(keyPath: "attributes")
        self.object.id = try? unboxer.unbox(key: "id")
    }

}
