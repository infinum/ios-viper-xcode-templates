//___FILEHEADER___
//  This file was generated by the 🐍 VIPER generator
//

import UIKit

final class ___VARIABLE_moduleName___Wireframe: BaseWireframe<___VARIABLE_moduleName___ViewController> {

    // MARK: - Private properties -

    // MARK: - Module setup -

    init() {
        let moduleViewController = ___VARIABLE_moduleName___ViewController()
        super.init(viewController: moduleViewController)

        let interactor = ___VARIABLE_moduleName___Interactor()
        let presenter = ___VARIABLE_moduleName___Presenter(interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension ___VARIABLE_moduleName___Wireframe: ___VARIABLE_moduleName___WireframeInterface {
}
