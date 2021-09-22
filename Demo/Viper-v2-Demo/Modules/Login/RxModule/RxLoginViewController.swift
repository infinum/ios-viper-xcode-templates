//
//  RxLoginViewController.swift
//  Viper-v2-Demo
//
//  Created by Zvonimir Medak on 22.09.2021..
//  Copyright (c) 2021 Infinum. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import RxSwift
import RxCocoa

final class RxLoginViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: RxLoginPresenterInterface!

    // MARK: - Private properties -
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var ballImageView: UIImageView!
    @IBOutlet private weak var stackViewBottomMargin: NSLayoutConstraint!

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle -

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        registerForKeyboardNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTapGesture()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - Extensions -

extension RxLoginViewController: RxLoginViewInterface {
}

private extension RxLoginViewController {

    func setupView() {
        let output = RxLogin.ViewOutput(actions: RxLoginActions(
            email: emailTextField.rx.text.asDriver(),
            password: passwordTextField.rx.text.asDriver(),
            login: loginButton.rx.tap.asSignal(),
            register: registerButton.rx.tap.asSignal())
        )

        let input = presenter.configure(with: output)
        initializeButtonAvailability(with: input.events.buttonAvailability)
    }

    func initializeButtonAvailability(with buttonAvailability: Driver<Bool>) {
        buttonAvailability
            .do(onNext: { [unowned self] buttonState in
                handleButtonState(for: loginButton, with: buttonState)
            })
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    func handleButtonState(for button: UIButton, with buttonState: Bool) {
        button.alpha = buttonState ? 1 : 0.3
    }

}

private extension RxLoginViewController {
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: .UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: .UIKeyboardWillHide,
            object: nil
        )
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height

        view.layoutIfNeeded()
        stackViewBottomMargin.constant = keyboardHeight
        view.setNeedsUpdateConstraints()

        UIView.animate(withDuration: 0.3) { [unowned self] in
            ballImageView.alpha = 0.0
            view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        view.layoutIfNeeded()
        stackViewBottomMargin.constant = 0
        view.setNeedsUpdateConstraints()

        UIView.animate(withDuration: 0.3) { [unowned self] in
            ballImageView.alpha = 1.0
            view.layoutIfNeeded()
        }
    }

    func setupTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGestureRecognizer)

        tapGestureRecognizer.rx.event
            .subscribe(onNext: { [unowned self] _ in
                view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
} 
