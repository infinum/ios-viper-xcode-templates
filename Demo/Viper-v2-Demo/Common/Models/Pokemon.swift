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
    var pokemonDescription: String?
    var imagePath: String?

    var height: Double?
    var weight: Double?
    var gender: String?

    enum CodingKeys: String, CodingKey {
        case type
        case id
        case name
        case pokemonDescription = "description"
        case imagePath = "image-url"
        case height
        case weight
        case gender
    }

    var imageURL: URL? {
        guard let path = imagePath else {
            return nil
        }
        let urlString = String(format: "https://pokeapi.infinum.co%@", path)
        return URL(string: urlString)
    }
    
}

extension Pokemon: HomeViewItemInterface {

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
