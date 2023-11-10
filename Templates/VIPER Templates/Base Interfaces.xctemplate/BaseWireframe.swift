//___FILEHEADER___

import UIKit

protocol WireframeInterface: AnyObject {
}

class BaseWireframe<ViewController> where ViewController: UIViewController {

    private weak var _viewController: ViewController?

    // We need it in order to retain the view controller reference upon first access
    private var temporaryStoredViewController: ViewController?

    init(viewController: ViewController) {
        temporaryStoredViewController = viewController
        _viewController = viewController
    }

}

extension BaseWireframe: WireframeInterface {

}

extension BaseWireframe {

    var viewController: ViewController {
        defer { temporaryStoredViewController = nil }
        guard let vc = _viewController else {
            fatalError(
            """
            The `ViewController` instance that the `_viewController` property holds
            was already deallocated in a previous access to the `viewController` computed property.

            If you don't store the `ViewController` instance as a strong reference
            at the call site of the `viewController` computed property,
            there is no guarantee that the `ViewController` instance won't be deallocated since the
            `_viewController` property has a weak reference to the `ViewController` instance.

            For the correct usage of this computed property, make sure to keep a strong reference
            to the `ViewController` instance that it returns.
            """
            )
        }
        return vc
    }

    var navigationController: UINavigationController? {
        return viewController.navigationController
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
