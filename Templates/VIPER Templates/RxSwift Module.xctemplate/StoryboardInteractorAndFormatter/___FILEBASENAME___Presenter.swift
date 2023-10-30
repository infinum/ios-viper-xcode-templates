//___FILEHEADER___
//  This file was generated by the 🐍 VIPER generator
//

import Foundation
import RxSwift
import RxCocoa

final class ___VARIABLE_moduleName___Presenter {
    
    // MARK: - Private properties -

    private unowned let view: ___VARIABLE_moduleName___ViewInterface
        private let formatter: ___VARIABLE_moduleName___FormatterInterface
    private let interactor: ___VARIABLE_moduleName___InteractorInterface
    private let wireframe: ___VARIABLE_moduleName___WireframeInterface

    // MARK: - Lifecycle -

    init(view: ___VARIABLE_moduleName___ViewInterface, formatter: ___VARIABLE_moduleName___FormatterInterface, interactor: ___VARIABLE_moduleName___InteractorInterface, wireframe: ___VARIABLE_moduleName___WireframeInterface) {
        self.view = view
        self.formatter = formatter
        self.interactor = interactor
        self.wireframe = wireframe
    }
}
// MARK: - Extensions -

extension ___VARIABLE_moduleName___Presenter: ___VARIABLE_moduleName___PresenterInterface {

    func configure(with output: ___VARIABLE_moduleName___.ViewOutput) -> ___VARIABLE_moduleName___.ViewInput {

        let formatterInput = ___VARIABLE_moduleName___.FormatterInput()

        let formatterOutput = formatter.format(for: formatterInput)

        return ___VARIABLE_moduleName___.ViewInput(models: formatterOutput)
    }

}
