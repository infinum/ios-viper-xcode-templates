# VIPER x SwiftUI Documentation

VIPER architecture is an architecture used to create scalable and maintainable applications. VIPER stands for View, Interactor, Presenter, Entity, and Router, and it separates architecture into distinct modules. Traditionally, VIPER architectures have relied on the UIKit framework for the UI layer. However, with the introduction of SwiftUI, it is now possible to use SwiftUI for the UI layer while still following the principles of the VIPER architecture.

## SwiftUI Overview

SwiftUI is a modern declarative framework introduced by Apple that allows developers to build user interfaces for iOS, macOS, watchOS, and tvOS applications. SwiftUI simplifies the UI development process by using declarative syntax and providing a wide range of built-in views and controls. It also supports reactive programming, enabling automatic updates to the UI when underlying data changes.

## Using SwiftUI in VIPER

To integrate SwiftUI into the VIPER architecture, we need to make some adjustments to the traditional VIPER components. Specifically, we'll focus on the Presenter and the UI layer (SwiftUI view). Here are the key modifications:

### Presenter Changes

In the traditional VIPER architecture, the Presenter typically conforms to a protocol defined for the UI layer. However, in the SwiftUI-based VIPER architecture, the Presenter no longer conforms to PresenterInterface protocol. Instead, it focuses on managing data flow between the Interactor and the SwiftUI view.

### UI Layer (SwiftUI View)

In the SwiftUI-based VIPER architecture, the UI layer is implemented using SwiftUI views. The SwiftUI view has a reference to the concrete Presenter object using the `@ObservedObject` property wrapper. This property wrapper ensures that the Presenter object persists across multiple updates of the view, maintaining its state.

To enable SwiftUI to work with the Presenter and update the UI accordingly, we leverage the `@Published` property wrapper, `@ObservedObject`, and the `ObservableObject` protocol. Here’s a short explanation to understand each of these concepts:

- `@Published` property wrapper: Used within the Presenter to mark specific properties that should trigger updates to the SwiftUI view when their values change. By annotating properties with `@Published`, SwiftUI automatically tracks and updates the UI whenever these properties change.

- `@ObservedObject` property wrapper: Used in the SwiftUI view to establish a reference to the concrete Presenter object. It ensures that the Presenter is initialized only once and persists across updates of the view. With `@ObservedObject`, the SwiftUI view retains the state of the Presenter and maintains a reference to it.

- `ObservableObject` protocol: The ObservableObject protocol is adopted by the Presenter, allowing SwiftUI to observe any changes made to the properties marked with `@Published`. By conforming to the ObservableObject protocol, the Presenter notifies SwiftUI whenever a `@Published` property changes, triggering an update to the UI.

## Code Examples

```swift
import SwiftUI

struct DemoView: View {
    @ObservedObject var presenter: DemoPresenter
    
    var body: some View {
        VStack {
            Text(presenter.name)
            Button(action: presenter.changeName) {
                Text("Tap to change label")
            }
        }
        .background(.primary)
    }
}

final class DemoPresenter: ObservableObject {
    @Published var name: String = "initial"

    func changeName() {
        name = "changed"
    }
}
```

## Communication
![iOS VIPER MODULES](/Images/ios_viper_swiftui_graph.jpg "iOS VIPER x SwiftUI GRAPH")

Let's take a look at the communication logic:
- View directly communicates with the Presenter.
- Wireframe instantiates the Presenter, Interactor, and SwiftUI View.
- Presenter communicates with Interactor via an InteractorInterface protocol.
- Presenter communicates with Wireframe via a WireframeInterface protocol.

The communication between most components of a module is done via protocols to ensure scoping of concerns and testability. Only the Wireframe communicates directly with the Presenter since it actually instantiates the Presenter, Interactor, and View and connects the three via dependency injection.

## Navigation

In the standard VIPER architecture, navigation is handled by the Wireframe component and UINavigationController. In this modified architecture, we decided to follow the same route.

### LazyHostingViewController

We introduced LazyHostingViewController to enable initialization of all required entities before a view is placed into a hierarchy. SwiftUI Views are created in Wireframes, but they need to be wrapped into a UIHostingController before being placed into a UIKit view hierarchy. They also need to be initialized with a presenter, and to create a presenter we need wireframe and interactor. To break the cyclic dependency between the Presenter, Wireframe, and SwiftUI view, we use the LazyHostingViewController.

### Usage of LazyHostingViewController

```swift
final class DemoWireframe: BaseWireframe<LazyHostingViewController<DemoView>> {

    init() {
        let moduleViewController = LazyHostingViewController<DemoView>()
        super.init(viewController: moduleViewController)

        let interactor = DemoInteractor()
        let presenter = DemoPresenter(interactor: interactor, wireframe: self)

        moduleViewController.rootView = DemoView(presenter: presenter)
    }

}
```
The LazyHostingViewController will initialize UIHostingController and add the SwiftUI view to the view hierarchy in the viewDidLoad lifecycle method.

### LazyHostingViewController in its entirety:

```swift
class LazyHostingViewController<RootView: View>: UIViewController {

    var rootView: RootView!
    private let isNavigationBarHidden: Bool
    
    init(isNavigationBarHidden: Bool = false) {
       self.isNavigationBarHidden = isNavigationBarHidden
       super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let hostingController = UIHostingController(rootView: rootView)
        
        hostingController.willMove(toParent: self)
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
}
```

To navigate between modules, we can utilize the UINavigationController provided by UIKit. We can push or present new Wireframes on the navigation stack based on user actions or application logic. The Wireframes handle the initialization and presentation of new modules, following the same process outlined above.

### Navigation code example:

```swift
import SwiftUI
struct NavigationDemoView: View {

    @ObservedObject var presenter: NavigationPresenter

    var body: some View {
      Button(action: presenter.navigateToDetailsScreen) {
          Text("Tap to navigate to details screen")
       }
    }

}

final class NavigationDemoPresenter: ObservableObject {

    private let interactor: NavigationDemoInteractorInterface
    private let wireframe: NavigationDemoWireframeInterface

    init(interactor: NavigationDemoInteractorInterface, wireframe: NavigationDemoWireframeInterface) {
        self.interactor = interactor
        self.wireframe = wireframe
    }

    func navigateToDetailsScreen() {
        wireframe.navigateToDetailsScreen()
    }

}

extension NavigationDemoWireframe: NavigationDemoWireframeInterface {

    func navigateToDetailsScreen() {
        let wireframe = DetailsDemoWireframe(testType)
        
        navigationController?.pushWireframe(wireframe)
    }

}

```

### HostingNavigationController (Optional)

If you want to create a navigation bar using SwiftUI views, the native navigation bar would have to be hidden. To create a navigation bar, we utilized simple SwiftUI views like HStack, Image, and Text. To hide a native navigation bar, we had some obstacles that we resolved by introducing HostingNavigationController.

HostingNavigationController is a subclass of the UINavigationController designed to be used exclusively with the LazyHostingViewController. It overrides the `setNavigationBarHidden(_:animated:)` method to always retrieve the preference for hiding the navigation bar from the currently pushed view controller's `HostingNavigationConfigurable` `shouldHideNavigationBar` parameter. This overrides any parameters passed to it. This is necessary because SwiftUI attempts to modify the navigation bar visibility during the layout process, even when it shouldn't.

```swift
class HostingNavigationController: UINavigationController {

    override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        guard let hostingChild = children.last as? HostingNavigationConfigurable
        else {
            super.setNavigationBarHidden(hidden, animated: animated)
            return
        }

        super.setNavigationBarHidden(hostingChild.shouldHideNavigationBar, animated: animated)
    }

}

protocol HostingNavigationConfigurable: AnyObject {
    var shouldHideNavigationBar: Bool { get }
}

```
HostingNavigationConfigurable protocol is adopted by LazyHostingViewController, which uses isNavigationBarHidden parameter passed during LazyHostingViewController initialization.

```swift
extension LazyHostingViewController: HostingNavigationConfigurable {

    var shouldHideNavigationBar: Bool { isNavigationBarHidden }

}
```
For project code examples and further details, please refer to the [SwiftUI x Viper Demo Project](../Demo/SwiftUI-Viper-Demo).
