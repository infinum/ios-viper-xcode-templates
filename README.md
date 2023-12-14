![iOS VIPER](/Images/ios_viper_logo.png "iOS VIPER")

# Versions

Latest version is v5.0

If you need to use any older version you can find them:
* 4.0.1 version [branch](https://github.com/infinum/iOS-VIPER-Xcode-Templates/tree/version/4.0.1)
* 4.0 version [branch](https://github.com/infinum/iOS-VIPER-Xcode-Templates/tree/version/4.0) - [Viper 4.0 Migration Guide](Documentation/Viper%204.0%20Migration%20Guide.md)
* 3.2 version [branch](https://github.com/infinum/iOS-VIPER-Xcode-Templates/tree/version/3.2)
* 3.1 version [branch](https://github.com/infinum/iOS-VIPER-Xcode-Templates/tree/version/3.1)
* 3.0 version [branch](https://github.com/infinum/iOS-VIPER-Xcode-Templates/tree/version/3.0)
* 2.0 version [branch](https://github.com/infinum/iOS-VIPER-Xcode-Templates/tree/version/2.0)

# Installation instructions

To install VIPER Xcode templates clone this repo and run the following command from the root folder:

> make install_templates

To uninstall Xcode template run:

> make uninstall_templates

After that, restart your Xcode if it was already opened.

## Demo project

There's a TV Shows demo project in Demo folder.
You can find the most common VIPER module use cases in it. If you're already familiar with the base Viper modules you can check out our [RxModule Guide](Documentation/Viper%20RxModule%20Guide.md).

If you want to check out how you could use Formatter in your apps, feel free to check out [Formatter Guide](Documentation/Formatter%20documentation.md).

## SwiftUI hosted module documentation and demo

The 5.0 version includes support for integrating SwiftUI into Viper modules. There's a simple demo project in the Demo folder.
The documentation for using SwiftUI hosted modules can be found in [Viper x SwiftUI Guide](Documentation/Viper%20x%20SwiftUI%20Guide.md).

# VIPER short introduction

How to organize all your code and not end up with a couple of <i>Massive View Controllers</i> with millions of lines of code?
In short, **VIPER (View Interactor Presenter Entity Router)** is an architecture that, among other things, aims at solving the common *Massive View Controller* problem in iOS apps. When implemented to its full extent it achieves complete separation of concerns between modules, which also yields testability. This is good because another problem with Apple's Model View Controller architecture is poor testability.

If you search the web for VIPER architecture in iOS apps you'll find a number of different implementations and a lot of them are not covered in enough detail. At Infinum we have tried out several approaches to this architecture in real-life projects and with that we have defined our own version of VIPER which we will try to cover in detail here.

Let's go over the basics quickly - the main components of VIPER are as follows:

* **View**: contains UI logic and knows how to layout and animate itself. It displays what it's _told_ by the Presenter and it _delegates_ user interaction actions to the Presenter. Ideally, it contains no business logic, only view logic.
* **Interactor**: used for fetching data when requested by the Presenter, regardless of where the data is coming from. Contains only business logic.
* **Presenter**: also known as the event handler. Handles all the communication with view, interactor, and wireframe. Contains presentation logic - basically it controls the module.
* **Entity**: models which are handled by the Interactor. Contains only business logic, but primarily data, not rules.
* **Formatter**(new): handles formatting logic. Sits between the presenter and the view. It formats the data from the business world into something that can be consumed by the view.
* **Router**: handles navigation logic. In our case, we use components called Wireframes for this responsibility.

## Components

Your entire app is made up of multiple modules which you organize in logical groups and use one storyboard for that group. In most cases the modules will represent screens and your module groups will represent user stories, business flows, and so on.

Module components:

* **View**
* **Presenter**
* **Interactor** (not mandatory)
* **Formatter** (not mandatory)
* **Wireframe**

In some simpler cases, you won't need an Interactor for a certain module, which is why this component is not mandatory. These are cases where you don't need to fetch any data, which is usually not common.

Wireframes inherit from the BaseWireframe. Presenters and Interactors do not inherit any class. Views most often inherit UIViewControllers. All protocols should be located in one file called *Interfaces*. More on this later.

## Communication and references

The following pictures show relationships and communication for one module.

![iOS VIPER GRAPH](/Images/ios_viper_graph.jpg "iOS VIPER GRAPH")

Let's take a look at the communication logic.

* *LoginViewController* communicates with *LoginPresenter* via a *LoginPresenterInterface* protocol
* *LoginPresenter* communicates with *LoginViewController* via a *LoginViewInterface* protocol
* *LoginPresenter* communicates with *LoginInteractor* via a *LoginInteractorInterface* protocol
* *LoginPresenter* communicates with *LoginWireframe* via a *LoginWireframeInterface* protocol

The communication between most components of a module is done via protocols to ensure scoping of concerns and testability. Only the Wireframe communicates directly with the Presenter since it actually instantiates the Presenter, Interactor, and View and connects the three via dependency injection.

Now let's take a look at the references logic.

* *LoginPresenter* has a **strong** reference to *LoginInteractor*
* *LoginPresenter* has a **strong** reference to *LoginWireframe*
* *LoginPresenter* has a **unowned** reference to *LoginViewController*
* *LoginViewController* has a **strong** reference to *LoginPresenter*


The reference types might appear a bit counter-intuitive, but they are organized this way to ensure all module components are not deallocated from memory as long as one of its Views is active. In this way, the Views lifecycle is also the lifecycle of the module - which actually makes perfect sense.

The creation and setup of module components are done in the Wireframe. The creation of a new Wireframe is almost always done in the previous Wireframe. More details on this later in the actual code.

Before we go into detail we should comment on one somewhat unusual decision we made naming-wise and that's suffixing protocol names with "Interface" (*LoginWireframeInterface*, *RegisterViewInterface*, ...). A common way to do this would be to omit the "Interface" part but we've found that this makes code somewhat less readable and the logic behind VIPER harder to grasp, especially when starting out.

## 1. Base classes and interfaces

The module generator tool will generate five files - but for these to work you will need a couple of base protocols and classes. To get them in your project you should create a new file in Xcode and from the template selection screen, under the VIPER Templates section, select BaseInterfaces, and put them in some common folder in your project, perhaps in Common/VIPER.
Let's start by covering these base files: *WireframeInterface*, *BaseWireframe*, *ViewInterface*, *InteractorInterface*, *PresenterInterface*, *UIStoryboardExtension*:

### WireframeInterface and BaseWireframe

```swift
import UIKit

protocol WireframeInterface: AnyObject {
}

class BaseWireframe<ViewController> where ViewController: UIViewController {

    private weak var _viewController: ViewController?

    // We need it in order to retain the view controller reference upon first access
    private var temporaryStoredViewController: ViewController?

    init(viewController: ViewController) {
        temporaryStoredViewController = viewController
        _viewController = viewController
    }

}

extension BaseWireframe: WireframeInterface {

}

extension BaseWireframe {

    var viewController: ViewController {
        defer { temporaryStoredViewController = nil }
        guard let vc = _viewController else {
            fatalError(
            """
            The `ViewController` instance that the `_viewController` property holds
            was already deallocated in a previous access to the `viewController` computed property.

            If you don't store the `ViewController` instance as a strong reference
            at the call site of the `viewController` computed property,
            there is no guarantee that the `ViewController` instance won't be deallocated since the
            `_viewController` property has a weak reference to the `ViewController` instance.

            For the correct usage of this computed property, make sure to keep a strong reference
            to the `ViewController` instance that it returns.
            """
            )
        }
        return vc
    }

    var navigationController: UINavigationController? {
        return viewController.navigationController
    }

}

extension UIViewController {

    func presentWireframe<ViewController>(_ wireframe: BaseWireframe<ViewController>, animated: Bool = true, completion: (() -> Void)? = nil) {
        present(wireframe.viewController, animated: animated, completion: completion)
    }

}

extension UINavigationController {

    func pushWireframe<ViewController>(_ wireframe: BaseWireframe<ViewController>, animated: Bool = true) {
        pushViewController(wireframe.viewController, animated: animated)
    }

    func setRootWireframe<ViewController>(_ wireframe: BaseWireframe<ViewController>, animated: Bool = true) {
        setViewControllers([wireframe.viewController], animated: animated)
    }

}
```

The Wireframe is used in 2 steps:

1. Initialization using a *UIViewController* (see the *init* method). Since the Wireframe is in charge of performing the navigation it needs access to the actual *UIViewController* with which it will do so.
2. Navigation to a screen (see the *pushWireframe*, *presentWireframe* and *setRootWireframe* methods).
Those methods are defined on *UIViewController* and *UINavigationController* since those objects are responsible for performing the navigation.

### ViewInterface, InteractorInterface, and PresenterInterface

```swift
protocol ViewInterface: AnyObject {
}

extension ViewInterface {
}
```

```swift
protocol InteractorInterface: AnyObject {
}

extension InteractorInterface {
}
```

```swift
protocol PresenterInterface: AnyObject {
}

extension PresenterInterface {
}
```

These interfaces are initially empty. They exist just to make it simple to insert any and all functions needed in all views/interactors/presenters in your project. *ViewInterface* and *InteractorInterface* protocols need to be class-bound because the Presenter will hold them via a weak reference.

Ok, let's get to the actual module. First, we'll cover the files you get when creating a new module via the module generator.

## 2. What you get when generating a module

When running the module generator you will get five files. Say we wanted to create a Home module, we would get the following: *HomeInterfaces*, *HomeWireframe*, *HomePresenter*, *HomeView*, and *HomeInteractor*. Let's go over all five.

### Interfaces

```swift
protocol HomeWireframeInterface: WireframeInterface {
}

protocol HomeViewInterface: ViewInterface {
}

protocol HomePresenterInterface: PresenterInterface {
}

protocol HomeInteractorInterface: InteractorInterface {
}
```

This interface file will provide you with a nice overview of your entire module in one place. Since most components communicate with each other via protocols we found it very useful to put all of these protocols for one module in one place. That way you have a very clean overview of the entire behavior of the module.

### Wireframe

```swift
final class HomeWireframe: BaseWireframe<HomeViewController> {

    // MARK: - Private properties -

    private let storyboard = UIStoryboard(name: "Home", bundle: nil)

    // MARK: - Module setup -

    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: HomeViewController.self)
        super.init(viewController: moduleViewController)

        let interactor = HomeInteractor()
        let presenter = HomePresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension HomeWireframe: HomeWireframeInterface {
}
```

It generates a Storyboard file for you too so you don't have to create one yourself. You can tailor the Storyboard to match its purpose.

### Presenter

```swift
final class HomePresenter {

    // MARK: - Private properties -

    private unowned let view: HomeViewInterface
    private let interactor: HomeInteractorInterface
    private let wireframe: HomeWireframeInterface

    // MARK: - Lifecycle -

    init(
        view: HomeViewInterface,
        interactor: HomeInteractorInterface,
        wireframe: HomeWireframeInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension HomePresenter: HomePresenterInterface {
}
```

This is the skeleton of a Presenter which will get a lot more meat on it once you start implementing the business logic.

### View

```swift
final class HomeViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: HomePresenterInterface!

    // MARK: - Life cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: - Extensions -

extension HomeViewController: HomeViewInterface {
}
```

Like the Presenter above, this is only a skeleton that you will populate with IBOutlets, animations and so on.

### Interactor

```swift
final class HomeInteractor {
}

extension HomeInteractor: HomeInteractorInterface {
}
```

When generated your Interactor is also a skeleton that you will in most cases use to perform fetching of data from remote API services, Database services, etc.

## 3. How it really works

Here's an example of a wireframe for a Home screen. Let's start with the Presenter.

```swift
final class HomePresenter {

    // MARK: - Private properties -

    private unowned let view: HomeViewInterface
    private let interactor: HomeInteractorInterface
    private let wireframe: HomeWireframeInterface

    private var items: [Show] = [] {
        didSet {
            view.reloadData()
        }
    }

    // MARK: - Lifecycle -

    init(
        view: HomeViewInterface,
        interactor: HomeInteractorInterface,
        wireframe: HomeWireframeInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension HomePresenter: HomePresenterInterface {
    func logout() {
        interactor.logout()
        wireframe.navigateToLogin()
    }

    var numberOfItems: Int {
        items.count
    }

    func item(at indexPath: IndexPath) -> Show {
        items[indexPath.row]
    }

    func itemSelected(at indexPath: IndexPath) {
        let show = items[indexPath.row]
        wireframe.navigateToShowDetails(id: show.id)
    }

    func loadShows() {
        view.showProgressHUD()
        interactor.getShows { [unowned self] result in
            switch result {
            case .failure(let error):
                showValidationError(error)
            case .success(let shows):
                items = shows
            }
            view.hideProgressHUD()
        }
    }

}

private extension HomePresenter {
    func showValidationError(_ error: Error) {
        wireframe.showAlert(with: "Error", message: error.localizedDescription)
    }
}
```

In this simple example, the Presenter fetches TV shows by doing an API call and handles the result. The Presenter can also handle the logout action and item selection in a tableView which is delegated from the view. If an item has been selected the Presenter will initiate the opening of the Details screen.

```swift
final class HomeWireframe: BaseWireframe<HomeViewController> {

    // MARK: - Private properties -

    private let storyboard = UIStoryboard(name: "Home", bundle: nil)

    // MARK: - Module setup -

    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: HomeViewController.self)
        super.init(viewController: moduleViewController)

        let interactor = HomeInteractor()
        let presenter = HomePresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension HomeWireframe: HomeWireframeInterface {
    func navigateToLogin() {
        navigationController?.setRootWireframe(LoginWireframe())
    }

    func navigateToShowDetails(id: String) {
        navigationController?.pushWireframe(DetailsWireframe())
    }

}
```

This is also a simple example of a wireframe that handles two navigation functions. You've maybe noticed the *showAlert* Wireframe method used in the Presenter to display alerts. This is used in the BaseWireframe in this concrete project and looks like this:

```swift
func showAlert(with title: String?, message: String?) {
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    showAlert(with: title, message: message, actions: [okAction])
}
```

This is just one example of some shared logic you'll want to put in your base class or maybe one of the base protocols.

Here's an example of a simple Interactor we used in the Demo project:

```swift
final class HomeInteractor {
    private let userService: UserService
    private let showService: ShowService

    init(userService: UserService = .shared, showService: ShowService = .shared) {
        self.userService = userService
        self.showService = showService
    }
}

// MARK: - Extensions -

extension HomeInteractor: HomeInteractorInterface {
    func getShows(_ completion: @escaping ((Result<[Show], Error>) -> ())) {
        showService.getShows(completion)
    }

    func logout() {
        userService.removeUser()
    }
}
```

The Interactor contains services that actually communicate with the server. The Interactor can contain as many services as needed but beware that you don't add the ones that aren't needed.


## How it's organized in Xcode

Using this architecture impacted the way we organize our projects. In most cases, we have four main subfolders in the project folder: Application, Common, Modules, and Resources. Let's go over those a bit.

### Application

Contains AppDelegate and any other app-wide components, initializers, appearance classes, managers and so on. Usually this folder contains only a few files.

### Common

Used for all common utility and view components grouped in subfolders. Some common cases for these groups are _Analytics_, _Constants_, _Extensions_, _Protocols_, _Views_, _Networking_, etc. Also here is where we always have a _VIPER_ subfolder which contains the base VIPER protocols and classes.

### Resources

This folder should contain image assets, fonts, audio and video files, and so on. We use one *.xcassets* for images and in that folder separate images into logical folders so we don't get a long list of files in one place.

### Modules

As described earlier you can think of one VIPER module as one screen. In the _Modules_ folder we organize screens into logical groups which are basically user stories. Each group is organized in a sub-folder which contains one storyboard (containing all screens for that group) and multiple module sub-folders.

![iOS VIPER MODULES](/Images/ios_viper_modules.png "iOS VIPER MODULES")

## Useful links

* https://www.objc.io/issues/13-architecture/viper/
* https://swifting.io/2016/03/07/VIPER-to-be-or-not-to-be.html

## Contributing and development

Feedback and code contributions are very much welcome. Just make a pull request with a short description of your changes.

Before creating a PR, please run:

    ruby main.rb

from `Templates` directory to generate all templates files.

By making contributions to this project you give permission for your code to be used under the same [license](License).

## Credits

Maintained and sponsored by
[Infinum](https://infinum.com).

<p align="center">
  <a href='https://infinum.com'>
    <picture>
        <source srcset="https://assets.infinum.com/brand/logo/static/white.svg" media="(prefers-color-scheme: dark)">
        <img src="https://assets.infinum.com/brand/logo/static/default.svg">
    </picture>
  </a>
</p>
