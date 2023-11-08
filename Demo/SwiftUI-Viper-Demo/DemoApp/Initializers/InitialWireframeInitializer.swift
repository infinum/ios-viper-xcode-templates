import Foundation
import UIKit

protocol AppWindowHandler: AnyObject {
    var window: UIWindow? { get set }
}

struct InitialWireframeInitializer: Initializable {

    weak var windowHandler: AppWindowHandler?

    private var launchOptions: [UIApplication.LaunchOptionsKey: Any]?

    init(windowHandler: AppWindowHandler?, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        self.windowHandler = windowHandler
        self.launchOptions = launchOptions
    }

    func initialize() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let vc = getFirstViewController()
        window.rootViewController = vc
        window.makeKeyAndVisible()
        windowHandler?.window = window
    }
}

private extension InitialWireframeInitializer {

    private func getFirstViewController() -> UIViewController {
        let navigationController = HostingNavigationController()

        let loginWireframe = LoginWireframe()
        navigationController.setRootWireframe(loginWireframe)

        return navigationController
    }

}
