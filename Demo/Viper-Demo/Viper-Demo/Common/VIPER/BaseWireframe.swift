import UIKit

protocol WireframeInterface: AnyObject {
    func showAlert(with title: String?, message: String?)
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

    func showAlert(with title: String?, message: String?) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        showAlert(with: title, message: message, actions: [okAction])
    }

    func showAlert(with title: String?, message: String?, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        navigationController?.present(alert, animated: true, completion: nil)
    }

}

extension BaseWireframe {

    /// > Warning: The reference to the `ViewController` that the method returns
    /// > needs to be kept strongly at the call site of the method in order for it to not be deallocated.
    func getDeallocatableViewController() -> ViewController {
        defer { temporaryStoredViewController = nil }
        guard let viewController = _viewController else {
            fatalError(
            """
            The `ViewController` instance that the `_viewController` property holds
            was already deallocated in a previous call to the `getDeallocatableViewController` method.

            If you don't store the `ViewController` instance as a strong reference
            at the call site of the `getDeallocatableViewController` method,
            there is no guarantee that the `ViewController` instance won't be deallocated since the
            `_viewController` property has a weak reference to the `ViewController` instance.

            For the correct usage of this method, make sure to keep a strong reference
            to the `ViewController` instance that the method returns.
            """
            )
        }
        return viewController
    }

    var navigationController: UINavigationController? {
        return getDeallocatableViewController().navigationController
    }

}

extension UIViewController {

    func presentWireframe<ViewController>(_ wireframe: BaseWireframe<ViewController>, animated: Bool = true, completion: (() -> Void)? = nil) {
        present(wireframe.getDeallocatableViewController(), animated: animated, completion: completion)
    }

}

extension UINavigationController {

    func pushWireframe<ViewController>(_ wireframe: BaseWireframe<ViewController>, animated: Bool = true) {
        pushViewController(wireframe.getDeallocatableViewController(), animated: animated)
    }

    func setRootWireframe<ViewController>(_ wireframe: BaseWireframe<ViewController>, animated: Bool = true) {
        setViewControllers([wireframe.getDeallocatableViewController()], animated: animated)
    }

}
