//
//  PokedexValidate.swift
//  Pokedex
//
//  Created by Filip Beć on 28/04/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import Alamofire

extension DataRequest {

    func pokedexValidate() -> Self {
        return validate { (request, response, data) -> Request.ValidationResult in
            guard let _data = data, !Array(200..<300).contains(response.statusCode) else {
                return .success
            }

            let responseObject = try? JSONSerialization.jsonObject(with: _data, options: [])
            guard let responseDict = responseObject as? [String: Any] else {
                return .success
            }
            guard let errorsArray = responseDict["errors"] as? [Any] else {
                return .success
            }
            guard let error = errorsArray.first as? [String: Any] else {
                return .success
            }
            guard let errorMessage = error["detail"] as? String else {
                return .success
            }
            return .failure(APIError.message(errorMessage))
        }.validate()
    }
}
