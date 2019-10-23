//
//  UserService.swift
//  Pokedex
//
//  Created by Filip Beć on 28/04/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import UIKit
import Alamofire
import Japx

typealias LoginCompletionBlock = (DataResponse<User>) -> (Void)

class UserService: NSObject {

    @discardableResult
    func loginUser(with email: String, password: String, completion: @escaping LoginCompletionBlock) -> DataRequest {

        let parameters: Parameters = [
            "data": [
                "type": "session",
                "attributes": [
                    "email": email,
                    "password": password
                ]
            ]
        ]

        return Alamofire.request(
            Constants.API.URLBase.appendingPathComponent("api/v1/users/login"),
            method: .post,
            parameters: parameters
            ).pokedexValidate().responseCodableJSONAPI(keyPath: "data", decoder: .kebabCaseDecoder, completionHandler: completion)
    }

    @discardableResult
    func registerUser(with username: String, email: String, password: String, confirmedPassword: String, completion: @escaping LoginCompletionBlock) -> DataRequest {

        let parameters: Parameters = [
            "data": [
                "type": "users",
                "attributes": [
                    "username":username,
                    "email": email,
                    "password": password,
                    "password_confirmation": confirmedPassword
                ]
            ]
        ]

        return Alamofire.request(
            Constants.API.URLBase.appendingPathComponent("api/v1/users"),
            method: .post,
            parameters: parameters
            ).pokedexValidate().responseCodableJSONAPI(keyPath: "data", decoder: .kebabCaseDecoder, completionHandler: completion)
    }

}
