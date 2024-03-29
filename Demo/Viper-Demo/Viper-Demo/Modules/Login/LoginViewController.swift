//
//  LoginViewController.swift
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

final class LoginViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: LoginPresenterInterface!

    // MARK: - Private properties -

    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var checkboxButton: UIButton!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var registerButton: UIButton!
    @IBOutlet private var secureEntryButton: UIButton!
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

// MARK: - Extensions -

extension LoginViewController: LoginViewInterface {
}

private extension LoginViewController {

    func setupView() {
        let remember = checkboxButton.rx.tap.asDriver()
            .scan(false) { previousValue, _ in !previousValue }
            .startWith(false)

        let output = Login.ViewOutput(actions: LoginActions(
            rememberMe: remember,
            login: loginButton.rx.tap.asSignal(),
            register: registerButton.rx.tap.asSignal(),
            email: emailTextField.rx.text.asDriver(),
            password: passwordTextField.rx.text.asDriver()
        ))

        let input = presenter.configure(with: output)
        handle(rememberMe: remember)
        handle(areActionsAvailable: input.events.areActionsAvailable)
        handle(secureEntry: secureEntryButton.rx.tap.asDriver())
    }

}

private extension LoginViewController {
    func handle(rememberMe: Driver<Bool>) {
        rememberMe
            .drive(checkboxButton.rx.isSelected)
            .disposed(by: disposeBag)
    }

    func handle(areActionsAvailable: Driver<Bool>) {
        areActionsAvailable
            .drive(registerButton.rx.isEnabled)
            .disposed(by: disposeBag)

        areActionsAvailable
            .map { $0 ? 1 : 0.3 }
            .drive(registerButton.rx.alpha)
            .disposed(by: disposeBag)

        areActionsAvailable
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)

        areActionsAvailable
            .map { $0 ? 1 : 0.3 }
            .drive(loginButton.rx.alpha)
            .disposed(by: disposeBag)
    }

    func handle(secureEntry: Driver<Void>) {
        let state = secureEntry
            .scan(true) { previousValue, _ in
                !previousValue
            }

        state
            .drive(secureEntryButton.rx.isSelected)
            .disposed(by: disposeBag)

        state
            .drive(passwordTextField.rx.isSecureTextEntry)
            .disposed(by: disposeBag)
    }
}
