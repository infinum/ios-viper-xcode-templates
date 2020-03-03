//
//  PokemonService.swift
//  Pokedex
//
//  Created by Filip Beć on 28/04/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import UIKit
import Alamofire
import Japx

typealias PokemonListCompletionBlock = (DataResponse<[Pokemon]>) -> (Void)

class PokemonService: NSObject {

    @discardableResult
    func getPokemons(_ completion: @escaping PokemonListCompletionBlock) -> DataRequest {
        return Alamofire.request(
            Constants.API.URLBase.appendingPathComponent("api/v1/pokemons"),
            method: .get
        ).pokedexValidate().responseCodableJSONAPI(keyPath: "data", decoder: .kebabCaseDecoder, completionHandler: completion)

    }

}
