//
//  Section.swift
//  Pokedex
//
//  Created by Filip Beć on 28/04/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import UIKit

struct Section<T> {
    var header: String?
    var footer: String?
    var items: [T] = []

    init(items: [T]) {
        self.items = items
    }
}
