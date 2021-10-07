//
//  ShowService.swift
//  Viper-Demo
//
//  Created by Zvonimir Medak on 06.10.2021..
//

import Foundation
import Alamofire
import Japx

class ShowService {

    static let shared = ShowService()

    private let japxDecoder = JapxDecoder()

    private init() {
        configureDecoder()
    }

    func getShows(_ completion: @escaping ((Result<[Show], Error>) -> ())) {
        AF.request(
            Constants.API.shows,
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default,
            interceptor: AuthInterceptor()
        ).validate().responseData { [unowned self] data in
            guard let data = data.data else {
                completion(.failure(data.error ?? AFError.explicitlyCancelled))
                return
            }
            do {
                let shows = try japxDecoder.decode(AllShowsResponse.self, from: data).shows
                completion(.success(shows))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

private extension ShowService {
    func configureDecoder() {
        japxDecoder.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
}
