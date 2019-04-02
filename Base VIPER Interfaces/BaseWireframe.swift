import UIKit

protocol WireframeInterface: class {
}

class BaseWireframe<View> where View: UIViewController {

    private unowned var _viewController: View
    
    //to retain view controller reference upon first access
    private var _temporaryStoredViewController: View?

    init(viewController: View) {
        _temporaryStoredViewController = viewController
        _viewController = viewController
    }

}

extension BaseWireframe: WireframeInterface {
    
}

extension BaseWireframe {
    
    var viewController: View {
        defer { _temporaryStoredViewController = nil }
        return _viewController
    }
    
    var navigationController: UINavigationController? {
        return viewController.navigationController
    }
    
}

extension UIViewController {
    
    func presentWireframe<View>(_ wireframe: BaseWireframe<View>, animated: Bool = true, completion: (() -> Void)? = nil) {
        present(wireframe.viewController, animated: animated, completion: completion)
    }
    
}

extension UINavigationController {
    
    func pushWireframe<View>(_ wireframe: BaseWireframe<View>, animated: Bool = true) {
        self.pushViewController(wireframe.viewController, animated: animated)
    }
    
    func setRootWireframe<View>(_ wireframe: BaseWireframe<View>, animated: Bool = true) {
        self.setViewControllers([wireframe.viewController], animated: animated)
    }
    
}
