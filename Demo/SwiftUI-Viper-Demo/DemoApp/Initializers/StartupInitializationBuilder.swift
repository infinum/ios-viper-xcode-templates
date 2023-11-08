import Foundation
import UIKit

final class StartupInitializationBuilder {

    private weak var appDelegate: AppDelegate?

}

extension StartupInitializationBuilder {

    func setAppDelegate(_ delegate: AppDelegate) -> StartupInitializationBuilder {
        appDelegate = delegate
        return self
    }

    func build(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> [Initializable] {
        var initializers: [Initializable] = []

        initializers.append(InitialWireframeInitializer(windowHandler: appDelegate, launchOptions: launchOptions))

        return initializers
    }

}
