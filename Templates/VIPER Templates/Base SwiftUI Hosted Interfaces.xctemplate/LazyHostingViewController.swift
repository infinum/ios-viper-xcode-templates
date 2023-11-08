//___FILEHEADER___

import SwiftUI
import UIKit

/// Hosting controller that should be used in modules that use SwiftUI for
/// creating their views. We are lazily adding the root view in order to
/// conform to our VIPER module structure.
///
/// The issue is that we need to
/// pass the presenter to our SwiftUI view as an ObservedObject, but to create
/// the presenter we need to first create the wireframe (and VC), leading to a
/// cycle that can only be broken by this lazy loading "hack".
///
/// Each `LazyHostingViewController` will be generic over the root view that is
/// contained inside it.
class LazyHostingViewController<RootView: View>: UIViewController {

    var rootView: RootView!
    private let isNavigationBarHidden: Bool

    init(isNavigationBarHidden: Bool = true, isModalInPresentation: Bool = false) {
        self.isNavigationBarHidden = isNavigationBarHidden
        super.init(nibName: nil, bundle: nil)
        self.isModalInPresentation = isModalInPresentation
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the hosting controller that will hold the SwiftUI view
        // and add it as a child view controller to self in order to properly
        // propagate all VC lifecycle events.
        //
        // You can see more about child VC handling here:
        // https://developer.apple.com/documentation/uikit/view_controllers/creating_a_custom_container_view_controller
        let hostingController = UIHostingController(rootView: rootView)
        view.addSubview(hostingController.view)
        addChild(hostingController)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        hostingController.didMove(toParent: self)
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: animated)
    }

}

extension LazyHostingViewController: HostingNavigationConfigurable {

    var shouldHideNavigationBar: Bool { isNavigationBarHidden }

}
