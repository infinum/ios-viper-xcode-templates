//
//  RxUserService.swift
//  Viper-v2-Demo
//
//  Created by Zvonimir Medak on 22.09.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import Foundation
import Alamofire
import Japx
import RxSwift
import RxCocoa

class RxUserService: UserServiceable {

    static let shared = RxUserService()

    private init(){}

    func login(with email: String, _ password: String) -> Single<User> {
        Single.create { single in
            let parameters: Parameters = [
                "data": [
                    "type": "session",
                    "attributes": [
                        "email": email,
                        "password": password
                    ]
                ]
            ]

            let request: DataRequest = Alamofire.request(
                Constants.API.URLBase.appendingPathComponent("api/v1/users/login"),
                method: .post,
                parameters: parameters
            ).pokedexValidate().responseData(queue: nil) { data in
                guard let data = data.data else {
                    single(.failure(RxError.unknown))
                    return
                }
                do {
                    let user = try JapxDecoder().decode(User.self, from: data, includeList: nil)
                    single(.success(user))
                } catch {
                    single(.failure(error))
                }

            }

            return Disposables.create {
                request.cancel()
            }
        }
    }
    
}
