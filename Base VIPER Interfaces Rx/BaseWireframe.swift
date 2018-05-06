import UIKit
import RxSwift
import RxCocoa

protocol WireframeInterface: class {
}

class BaseWireframe {

    let disposeBag = DisposeBag()

    private unowned var _viewController: UIViewController
    
    //to retain view controller reference upon first access
    private var _temporaryStoredViewController: UIViewController?

    init(viewController: UIViewController) {
        _temporaryStoredViewController = viewController
        _viewController = viewController
    }

}

extension BaseWireframe: WireframeInterface {
    
}

extension BaseWireframe {
    
    var viewController: UIViewController {
        defer { _temporaryStoredViewController = nil }
        return _viewController
    }
    
    var navigationController: UINavigationController? {
        return viewController.navigationController
    }
    
}

extension BaseWireframe {
    
    func subscribe<W: BaseWireframe, T>(to navigationOptionDriver: Driver<T>, unowning object: W, navigationBlock: @escaping (W)->((T)->())) {
        navigationOptionDriver
            .drive(onNext: { [unowned object] in navigationBlock(object)($0) })
            .disposed(by: disposeBag)
    }
    
}

extension UIViewController {
    
    func presentWireframe(_ wireframe: BaseWireframe, animated: Bool = true, completion: (()->())? = nil) {
        present(wireframe.viewController, animated: animated, completion: completion)
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
