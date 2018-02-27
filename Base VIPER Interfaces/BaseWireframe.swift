import UIKit

protocol WireframeInterface: class {
    func popFromNavigationController(animated: Bool)
    func dismiss(animated: Bool)
}

class BaseWireframe {

    private unowned var _viewController: UIViewController
    private var vcDealloc: UIViewController?

    init(viewController: UIViewController) {
        _viewController = viewController
        vcDealloc = viewController
    }

}

extension BaseWireframe {
    
    var viewController: UIViewController {
        defer { vcDealloc = nil }
        return _viewController
    }
    
    var navigationController: UINavigationController? {
        return viewController.navigationController
    }
    
    func presentWireframe(_ wireframe: BaseWireframe, animated: Bool = true, completion: (()->())? = nil) {
        viewController.present(wireframe.viewController, animated: animated, completion: completion)
    }
}

extension UINavigationController {
    
    func pushWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        self.pushViewController(wireframe.viewController, animated: animated)
    }
    
    func setRootWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        self.setViewControllers([wireframe.viewController], animated: animated)
    }
    
}

extension BaseWireframe: WireframeInterface {

    func popFromNavigationController(animated: Bool) {
        let _ = navigationController?.popViewController(animated: animated)
    }

    func dismiss(animated: Bool) {
        viewController.dismiss(animated: animated)
    }

}
