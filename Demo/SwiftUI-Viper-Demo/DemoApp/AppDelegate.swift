import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, AppWindowHandler {

    // MARK: - Public properties -

    var window: UIWindow?

    var initializers: [Initializable] = [] {
        didSet { initializers.forEach { $0.initialize() } }
    }

    // MARK: Lifecycle

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        initializers = StartupInitializationBuilder()
            .setAppDelegate(self)
            .build(with: launchOptions)

        return true
    }

}

