import Foundation
import Combine

final class HomePresenter: ObservableObject {

    // MARK: - Private properties -

    private let wireframe: HomeWireframeInterface
    let email: String

    // MARK: - Lifecycle -

    init(wireframe: HomeWireframeInterface, email: String) {
        self.wireframe = wireframe
        self.email = email
    }

    func goBack() {
        wireframe.goBack()
    }

}
