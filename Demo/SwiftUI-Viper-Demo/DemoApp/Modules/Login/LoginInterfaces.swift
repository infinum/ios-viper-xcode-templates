import UIKit

protocol LoginWireframeInterface: WireframeInterface {
    func showHomeScreen(email: String)
}

protocol LoginInteractorInterface: InteractorInterface {
    func login(with email: String)
}
