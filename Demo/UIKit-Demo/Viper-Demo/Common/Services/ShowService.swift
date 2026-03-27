//
//  ShowService.swift
//  Viper-Demo
//
//  Created by Zvonimir Medak on 06.10.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import Foundation
import Alamofire
import Japx
import RxSwift

class ShowService {

    static let shared = ShowService()

    private let japxDecoder = JapxDecoder()

    private init() {
        configureDecoder()
    }

    func getShows(_ completion: @escaping ((Result<[Show], Error>) -> Void)) {
        AF.request(
            Constants.API.shows,
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default,
            interceptor: AuthInterceptor()
        )
            .validate()
            .responseData { [unowned self] data in
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

    func getAllReviews(for showId: String) -> Single<[Review]> {
        return Single.create { single in
            let request = AF.request(
                Constants.API.showDetails.appendingPathComponent(showId).appendingPathComponent("/reviews"),
                method: .get,
                encoding: URLEncoding.default,
                interceptor: AuthInterceptor()
            )
                .validate()
                .responseData { [unowned self] data in
                    guard let data = data.data else {
                        single(.failure(data.error ?? AFError.explicitlyCancelled))
                        return
                    }
                    do {
                        let reviews = try japxDecoder.decode(ReviewResponse.self, from: data).reviews
                        single(.success(reviews))
                    } catch {
                        single(.failure(error))
                    }

                }

            return Disposables.create {
                request.cancel()
            }
        }
    }

    func getShowDetails(for showId: String) -> Single<Show> {
        return Single.create { single in
            let request = AF.request(
                Constants.API.showDetails.appendingPathComponent(showId),
                method: .get,
                encoding: URLEncoding.default,
                interceptor: AuthInterceptor()
            )
                .validate()
                .responseData { [unowned self] data in
                    guard let data = data.data else {
                        single(.failure(data.error ?? AFError.explicitlyCancelled))
                        return
                    }
                    do {
                        let show = try japxDecoder.decode(ShowDetailsResponse.self, from: data).show
                        single(.success(show))
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

private extension ShowService {
    func configureDecoder() {
        japxDecoder.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
}
