//
//  Pokemon.swift
//  Pokedex
//
//  Created by Filip Beć on 28/04/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import UIKit
import Unbox

class Pokemon: JSONAPIModel {

    var id: String?
    var name: String?
    var pokemonDescription: String?
    var imagePath: String?

    var height: Float?
    var weight: Float?
    var gender: String?

    required init(unboxer: Unboxer) throws {
        name = unboxer.unbox(key: "name")
        pokemonDescription = unboxer.unbox(key: "description")
        imagePath = unboxer.unbox(key: "image-url")
        height = unboxer.unbox(key: "height")
        weight = unboxer.unbox(key: "weight")
        gender = unboxer.unbox(key: "gender")
    }

    var type: String {
        return "pokemons"
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
