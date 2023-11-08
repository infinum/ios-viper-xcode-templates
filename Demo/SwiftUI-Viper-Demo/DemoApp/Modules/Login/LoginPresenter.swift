import Foundation
import Combine

final class LoginPresenter: ObservableObject {

    // MARK: - Public properties -

    @Published var emailInput: String = ""

    // MARK: - Private properties -

    private let interactor: LoginInteractorInterface
    private let wireframe: LoginWireframeInterface

    // MARK: - Lifecycle -

    init(
        interactor: LoginInteractorInterface,
        wireframe: LoginWireframeInterface
    ) {
        self.interactor = interactor
        self.wireframe = wireframe
    }

    func loginUser() {
        interactor.login(with: emailInput)
        wireframe.showHomeScreen(email: emailInput)
    }
}
