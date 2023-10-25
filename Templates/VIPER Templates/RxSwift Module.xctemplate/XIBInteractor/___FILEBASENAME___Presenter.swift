//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation
import RxSwift
import RxCocoa

final class ___VARIABLE_moduleName___Presenter {
    
    // MARK: - Private properties -

    private unowned let view: ___VARIABLE_moduleName___ViewInterface
        private let interactor: ___VARIABLE_moduleName___InteractorInterface
    private let wireframe: ___VARIABLE_moduleName___WireframeInterface

    // MARK: - Lifecycle -

    init(view: ___VARIABLE_moduleName___ViewInterface, interactor: ___VARIABLE_moduleName___InteractorInterface, wireframe: ___VARIABLE_moduleName___WireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}
// MARK: - Extensions -

extension ___VARIABLE_moduleName___Presenter: ___VARIABLE_moduleName___PresenterInterface {

    func configure(with output: ___VARIABLE_moduleName___.ViewOutput) -> ___VARIABLE_moduleName___.ViewInput {
        return ___VARIABLE_moduleName___.ViewInput()
    }

}