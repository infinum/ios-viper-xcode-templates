import Foundation
import SwiftUI

struct HomeView: View {

    @ObservedObject var presenter: HomePresenter
    @State private var isRotated: Bool = false

    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            Button(action: presenter.goBack) {
                Image(systemName: "chevron.left")
                    .font(.title2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
                

            Spacer()
            Text("Hi, \(presenter.email) 👋🏽👋🏽👋🏽")
                .rotationEffect(.degrees(isRotated ? 90 : 0))
            Text("Welcome to your new app.")

            Button("Do something") {
                withAnimation {
                    isRotated.toggle()
                }
            }

            Spacer()
        }
        .padding(16)
    }
}
