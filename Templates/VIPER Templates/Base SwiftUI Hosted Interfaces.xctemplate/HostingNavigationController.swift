//___FILEHEADER___

import UIKit

/// Navigation controller that should be used only in combination with the ``LazyHostingViewController``.
///
/// It overrides the ``setNavigationBarHidden(_:animated:)`` method in a way where it will always ask
/// the currently pushed view controller for its preference stored in the ``HostingNavigationConfigurable/shouldHideNavigationBar``
/// parameter, ignoring any actual parameters passed to it.
///
/// This is done in such a way because at some point during the layout process SwiftUI also
/// tries to change the current navigation bar visibility even thouh it shouldn't.
class HostingNavigationController: UINavigationController {

    override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        guard let hostingChild = children.last as? HostingNavigationConfigurable
        else {
            // In case the last pushed controller is not a HostingNavigationConfigurable,
            // we can simply call super here since we're not dealing with SwiftUI
            // but with regular UIKit.
            super.setNavigationBarHidden(hidden, animated: animated)
            return
        }

        super.setNavigationBarHidden(hostingChild.shouldHideNavigationBar, animated: animated)
    }

}
