//
//  HomeWireframe.swift
//  Viper-v2-Demo
//
//  Created by Donik Vrsnak on 4/11/18.
//  Copyright (c) 2018 Infinum. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit

final class HomeWireframe: BaseWireframe {

    // MARK: - Private properties -

    private let _storyboard = UIStoryboard(name: "Home", bundle: nil)

    // MARK: - Module setup -

    init() {
        let moduleViewController = _storyboard.instantiateViewController(ofType: HomeViewController.self)
        super.init(viewController: moduleViewController)
        
        let interactor = HomeInteractor()
        let presenter = HomePresenter(wireframe: self, view: moduleViewController, interactor: interactor)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension HomeWireframe: HomeWireframeInterface {

    func navigate(to option: HomeNavigationOption) {
    }
}
