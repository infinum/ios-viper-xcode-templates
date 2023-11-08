import Foundation
import SwiftUI

struct LoginView: View {

    @ObservedObject var presenter: LoginPresenter

    var body: some View {
        VStack(spacing: 20) {
            Text("Please enter your email below 😄")
            TextField("Enter email", text: $presenter.emailInput)
                .padding(5)
                .background(Color.gray.opacity(0.3))
            Button("Login") {
                presenter.loginUser()
            }
        }
        .padding(.horizontal, 20)
    }
}
