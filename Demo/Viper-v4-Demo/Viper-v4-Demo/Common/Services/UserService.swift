//
//  UserService.swift
//  Viper-v4-Demo
//
//  Created by Zvonimir Medak on 05.10.2021..
//

import Foundation
import Japx
import RxSwift
import Alamofire

class UserService {

    static let shared = UserService()

    private let userDefaults: UserDefaults

    private init() {
        userDefaults = .standard
    }

    func login(with email: String, _ password: String) -> Single<User> {
        Single.create { single in
            var params = Parameters()
            params["email"] = email
            params["password"] = password
            let request = AF.request(
                Constants.API.login,
                method: .post,
                parameters: params,
                encoding: URLEncoding.default
            ).validate().responseData { data in
                guard let data = data.data else {
                    single(.failure(data.error ?? AFError.explicitlyCancelled))
                    return
                }
                do {
                    let user = try JapxDecoder().decode(User.self, from: data)
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

    func register(with email: String, _ password: String) -> Single<User> {
        Single.create { single in
            var params = Parameters()
            params["email"] = email
            params["password"] = password
            let request = AF.request(
                Constants.API.register,
                method: .post,
                parameters: params,
                encoding: URLEncoding.default
            ).validate().responseData { data in
                guard let data = data.data else {
                    single(.failure(data.error ?? AFError.explicitlyCancelled))
                    return
                }
                do {
                    let user = try JapxDecoder().decode(User.self, from: data)
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

    func rememberUser() {
        userDefaults.set(true, forKey: Constants.UserDefaults.remember)
    }

    func removeUser() {
        userDefaults.removeObject(forKey: Constants.UserDefaults.remember)
    }
}
