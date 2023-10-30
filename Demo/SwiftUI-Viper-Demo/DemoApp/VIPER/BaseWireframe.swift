import UIKit

protocol WireframeInterface: Progressable {
}

class BaseWireframe<ViewController> where ViewController: UIViewController {

    private unowned var _viewController: ViewController

    // We need it in order to retain view controller reference upon first access
    private var temporaryStoredViewController: ViewController?

    init(viewController: ViewController) {
        temporaryStoredViewController = viewController
        _viewController = viewController
    }

}

extension BaseWireframe {

    var viewController: ViewController {
        defer { temporaryStoredViewController = nil }
        return _viewController
    }

    var navigationController: UINavigationController? {
        return viewController.navigationController
    }

    // This method is needed to fix frame issues on the root view after
    // a modal is being presented on top of it. The issue occurs only on iOS 16
    // and can be fixed by modal view not being fully expanded.
    @available(iOS 16.0, *)
    func setupModalDetent(on navigationController: UINavigationController) {
        let modalDetentId = UISheetPresentationController.Detent.Identifier(UUID().uuidString)
        let modalDetent = UISheetPresentationController.Detent.custom(identifier: modalDetentId) { context in
            context.maximumDetentValue * 0.99
        }

        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [modalDetent]
        }
    }

}

extension UIViewController {

    func presentWireframe<ViewController>(_ wireframe: BaseWireframe<ViewController>, animated: Bool = true, completion: (() -> Void)? = nil) {
        present(wireframe.viewController, animated: animated, completion: completion)
    }

}

extension UINavigationController {

    func pushWireframe<ViewController>(_ wireframe: BaseWireframe<ViewController>, animated: Bool = true) {
        pushViewController(wireframe.viewController, animated: animated)
    }

    func setRootWireframe<ViewController>(_ wireframe: BaseWireframe<ViewController>, animated: Bool = true) {
        setViewControllers([wireframe.viewController], animated: animated)
    }

}

extension BaseWireframe: WireframeInterface {

    func showLoading(status: String? = nil) {
    }

    func hideLoading() {
    }

    func show(error: Error) {
    }

}
