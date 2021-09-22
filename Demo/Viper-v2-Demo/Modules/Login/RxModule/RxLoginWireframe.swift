//
//  RxLoginWireframe.swift
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

final class RxLoginWireframe: BaseWireframe {

    // MARK: - Private properties -
    private let storyboard = UIStoryboard(name: "RxLogin", bundle: nil)
    // MARK: - Module setup -

    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: RxLoginViewController.self)
        super.init(viewController: moduleViewController)

        let interactor = RxLoginInteractor()
        let presenter = RxLoginPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension RxLoginWireframe: RxLoginWireframeInterface {
    func navigate(to option: LoginNavigationOption) {
        switch option {
        case .home:
            openHome()
        case .register:
            presentRegister()
        }

    }

    private func openHome() {
        let wireframe = HomeWireframe()

        navigationController?.pushWireframe(wireframe)
    }

    private func presentRegister() {
        let wireframe = RegisterWireframe()

        let wireframeNavigationController = PokedexNavigationController()
        wireframeNavigationController.setRootWireframe(wireframe)

        navigationController?.present(wireframeNavigationController, animated: true, completion: nil)
    }
}
