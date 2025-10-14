//
//  AuthInterceptor.swift
//  Viper-Demo
//
//  Created by Zvonimir Medak on 07.10.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import Foundation
import Alamofire

public class AuthInterceptor: RequestInterceptor {

    private let userDefaults = UserDefaults.standard

    public func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var urlRequest = urlRequest
        urlRequest.setValue(Constants.RequestInterceptor.acceptFormat, forHTTPHeaderField: Constants.RequestInterceptor.accept)

        guard let token = userDefaults.string(forKey: Constants.UserDefaults.token),
              let client = userDefaults.string(forKey: Constants.UserDefaults.client),
              let expiry = userDefaults.string(forKey: Constants.UserDefaults.expiry),
              let uid = userDefaults.string(forKey: Constants.UserDefaults.uid) else {
                  completion(.success(urlRequest))
                  return
        }

        urlRequest.setValue(token, forHTTPHeaderField: Constants.RequestInterceptor.accessToken)
        urlRequest.setValue(client, forHTTPHeaderField: Constants.RequestInterceptor.client)
        urlRequest.setValue(expiry, forHTTPHeaderField: Constants.RequestInterceptor.expiry)
        urlRequest.setValue(Constants.RequestInterceptor.bearer, forHTTPHeaderField: Constants.RequestInterceptor.tokenType)
        urlRequest.setValue(uid, forHTTPHeaderField: Constants.RequestInterceptor.uid)
        completion(.success(urlRequest))
    }
}
