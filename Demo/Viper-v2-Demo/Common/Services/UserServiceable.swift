//
//  UserServiceable.swift
//  Viper-v2-Demo
//
//  Created by Zvonimir Medak on 22.09.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import Foundation
import RxSwift

protocol UserServiceable {
    func login(with email: String, _ password: String) -> Single<User>
}
