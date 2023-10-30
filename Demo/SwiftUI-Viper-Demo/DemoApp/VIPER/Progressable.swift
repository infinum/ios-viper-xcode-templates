import UIKit
import Foundation

public typealias UIAlertActionHandler = ((UIAlertAction) -> Void)

public protocol Progressable: AnyObject {
    func showLoading(status: String?)
    func hideLoading()
    func show(error: Error)
    func show(error: Error, handler: UIAlertActionHandler?)
}

extension Progressable {
    func show(error: Error, handler: UIAlertActionHandler?) {
        show(error: error)
    }

    func showLoading(status: String? = nil) {
        showLoading(status: status)
    }
}
