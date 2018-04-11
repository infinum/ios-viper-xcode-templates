//
//  PokemonService.swift
//  Pokedex
//
//  Created by Filip Beć on 28/04/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import UIKit
import Alamofire
import UnboxedAlamofire

typealias PokemonListCompletionBlock = (DataResponse<[JSONAPIObject<Pokemon>]>) -> (Void)

class PokemonService: NSObject {

    @discardableResult
    func getPokemons(_ completion: @escaping PokemonListCompletionBlock) -> DataRequest {
        return Alamofire.request(
            "https://pokeapi.infinum.co/api/v1/pokemons",
            method: .get
        ).pokedexValidate().responseArray(keyPath: "data", completionHandler: completion)
    }

}
