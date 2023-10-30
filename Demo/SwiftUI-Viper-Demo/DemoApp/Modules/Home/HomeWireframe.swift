import UIKit

final class HomeWireframe: BaseWireframe<LazyHostingViewController<HomeView>> {

    // MARK: - Module setup -

    init(email: String) {
        let moduleViewController = LazyHostingViewController<HomeView>(isNavigationBarHidden: true)

        super.init(viewController: moduleViewController)

        let presenter = HomePresenter(wireframe: self, email: email)

        moduleViewController.rootView = HomeView(presenter: presenter)
    }

}

// MARK: - Extensions -

extension HomeWireframe: HomeWireframeInterface {

    func goBack() {
        navigationController?.popViewController(animated: true)
    }

}
