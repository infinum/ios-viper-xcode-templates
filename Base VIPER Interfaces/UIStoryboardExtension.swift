import UIKit

extension UIStoryboard {

    func instantiateViewController<T: UIViewController>(ofType _: T.Type, withIdentifier identifier: String? = nil) -> T {
        let identifier = identifier ?? String(describing: T.self)

        // swiftlint:disable:next force_cast
        return instantiateViewController(withIdentifier: identifier) as! T
    }

}
