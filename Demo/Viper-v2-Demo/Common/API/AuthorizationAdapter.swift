//
//  AuthTokenAdapter.swift
//  Pokedex
//
//  Created by Filip Beć on 28/04/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import Alamofire

class AuthorizationAdapter: RequestAdapter {

    static let shared = AuthorizationAdapter()

    var authorizationHeader: String? = nil

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue(authorizationHeader, forHTTPHeaderField: Constants.API.AuthorizationHeader)
        return urlRequest
    }

}
