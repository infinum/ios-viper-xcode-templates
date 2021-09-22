//
//  RxLoginInteractor.swift
//  Viper-v2-Demo
//
//  Created by Zvonimir Medak on 22.09.2021..
//  Copyright (c) 2021 Infinum. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation
import RxSwift

final class RxLoginInteractor {

    private let userServiceable: UserServiceable

    init(userServiceable: UserServiceable = RxUserService.shared) {
        self.userServiceable = userServiceable
    }
}

// MARK: - Extensions -

extension RxLoginInteractor: RxLoginInteractorInterface {
    func login(with email: String, _ password: String) -> Single<User> {
        userServiceable.login(with: email, password)
    }
}