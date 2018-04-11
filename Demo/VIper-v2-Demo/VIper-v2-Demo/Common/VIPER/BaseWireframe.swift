import UIKit
import SafariServices

protocol WireframeInterface: class {
    func popFromNavigationController(animated: Bool)
    func dismiss(animated: Bool)
    
    func openURL(_ url: URL)
    
    func showErrorAlert(with message: String?)
    func showAlert(with title: String?, message: String?)
    func showAlert(with title: String?, message: String?, actions: [UIAlertAction])
}

class BaseWireframe : NSObject {

    fileprivate unowned var _viewController: UIViewController
    
    //to retain view controller reference upon first access
    fileprivate var _temporaryStoredViewController: UIViewController?

    @objc init(viewController: UIViewController) {
        _temporaryStoredViewController = viewController
        _viewController = viewController
    }

}

extension BaseWireframe: WireframeInterface {
    @objc func popFromNavigationController(animated: Bool) {
        let _ = navigationController?.popViewController(animated: animated)
    }
    
    @objc func dismiss(animated: Bool) {
        navigationController?.dismiss(animated: animated)
    }
    
    @objc func openURL(_ url: URL) {
        let safari = SFSafariViewController(url: url)
        safari.delegate = self
        self.navigationController?.present(safari, animated: true, completion: nil)
    }
    
    @objc func showErrorAlert(with message: String?) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        showAlert(with: "Something went wrong", message: message, actions: [okAction])
    }
    
    @objc func showAlert(with title: String?, message: String?) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        showAlert(with: title, message: message, actions: [okAction])
    }
    
    @objc func showAlert(with title: String?, message: String?, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        navigationController?.present(alert, animated: true, completion: nil)
    }
}

extension BaseWireframe {
    
    @objc var viewController: UIViewController {
        defer { _temporaryStoredViewController = nil }
        return _viewController
    }
    
    @objc var navigationController: UINavigationController? {
        return viewController.navigationController
    }
    
}

extension UIViewController {
    
    @objc func presentWireframe(_ wireframe: BaseWireframe, animated: Bool = true, completion: (()->())? = nil) {
        present(wireframe.viewController, animated: animated, completion: completion)
    }
    
}

extension UINavigationController {
    
    @objc func pushWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        self.pushViewController(wireframe.viewController, animated: animated)
    }
    
    @objc func setRootWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        self.setViewControllers([wireframe.viewController], animated: animated)
    }
    
}

extension BaseWireframe: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
