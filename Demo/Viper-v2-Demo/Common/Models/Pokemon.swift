//
//  Pokemon.swift
//  Pokedex
//
//  Created by Filip Beć on 28/04/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import UIKit
import Japx

struct Pokemon: JapxCodable {
    var type: String

    var id: String
    var name: String?
    var description: String?
    var imageUrl: PartialURL?

    var height: Double?
    var weight: Double?
    var gender: String?

}

extension Pokemon: HomeViewItemInterface {
    var imageURL: URL? {
        return imageUrl?.url
    }

    var title: String? {
        return name
    }
}

extension Pokemon: PokemonDetailsDescriptionItemInterface {

    var pokemonName: String? {
        return name
    }
}

extension Pokemon: PokemonDetailsCharacteristicsItemInterface {
}
