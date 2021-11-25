import UIKit

protocol WireframeInterface: AnyObject {
    func showAlert(with title: String?, message: String?)
}

class BaseWireframe<ViewController> where ViewController: UIViewController {

    private unowned var _viewController: ViewController
    
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
    
    var viewController: ViewController {
        defer { temporaryStoredViewController = nil }
        return _viewController
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
