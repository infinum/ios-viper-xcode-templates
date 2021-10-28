//
//  LoginInterfaces.swift
//  Viper-Demo
//
//  Created by Zvonimir Medak on 05.10.2021..
//  Copyright (c) 2021 Infinum. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import RxSwift
import RxCocoa

protocol LoginWireframeInterface: WireframeInterface {
    func navigateToHome()
}

protocol LoginViewInterface: ViewInterface {
}

protocol LoginPresenterInterface: PresenterInterface {
    func configure(with output: Login.ViewOutput) -> Login.ViewInput
}

protocol LoginInteractorInterface: InteractorInterface {
    func login(with email: String, _ password: String) -> Single<User>
    func register(with email: String, _ password: String) -> Single<User>
    func rememberUser()
}

enum Login {

    struct ViewOutput {
        let actions: LoginActions
    }

    struct ViewInput {
        let events: LoginEvents
    }

}

struct LoginActions {
    let rememberMe: Driver<Bool>
    let login: Signal<Void>
    let register: Signal<Void>
    let email: Driver<String?>
    let password: Driver<String?>
}

struct LoginEvents {
    let areActionsAvailable: Driver<Bool>
}
