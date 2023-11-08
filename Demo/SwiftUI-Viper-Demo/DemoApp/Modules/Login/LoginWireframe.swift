import UIKit

final class LoginWireframe: BaseWireframe<LazyHostingViewController<LoginView>> {

    // MARK: - Module setup -

    init() {
        let moduleViewController = LazyHostingViewController<LoginView>(isNavigationBarHidden: true)

        super.init(viewController: moduleViewController)

        let interactor = LoginInteractor()
        let presenter = LoginPresenter(interactor: interactor, wireframe: self)

        moduleViewController.rootView = LoginView(presenter: presenter)
    }

}

// MARK: - Extensions -

extension LoginWireframe: LoginWireframeInterface {

    func showHomeScreen(email: String) {
        let homeWireframe = HomeWireframe(email: email)

        navigationController?.pushWireframe(homeWireframe)
    }

}
