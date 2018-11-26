![iOS VIPER](/Images/ios_viper_logo.png "iOS VIPER")

# Versions
Latest version is v2. You can still use initial v1 of the VIPER templates generator. v2 has breaking changes in base VIPER methods related to wireframe setup and navigation and is recommended to use it if starting a new project. It's not backwards compatible with v1.

# Installation instructions

To install VIPER Xcode templates clone this repo and run the following command from root folder:

> make install_templates

To uninstall Xcode template run:

> make uninstall_templates

After that, restart your Xcode if it was already opened.

## Demo project

There's a Pokemon demo project in Demo folder.
You can find most common VIPER module use cases in it.

## VIPER short introduction

How to organize all your code and not end up with a couple of <i>Massive View Controllers</i> with millions of lines of code?
In short, **VIPER (View Interactor Presenter Entity Router)** is an architecture which, among other things, aims at solving the common *Massive View Controller* problem in iOS apps. When implemented to its full extent it achieves complete separation of concerns between modules, which also yields testability. This is good because another problem with Apple's Model View Controller architecture is poor testability.

If you search the web for VIPER architecture in iOS apps you'll find a number of different implementations and a lot of them are not covered in enough detail. At Infinum we have tried out several approaches to this architecture in real-life projects and with that we have defined our own version of VIPER which we will try to cover in detail here.

Let's go over the basics quickly - the main components of VIPER are as follows:

* **View**: contains UI logic and knows how to layout and animate itself. It displays what it's _told_ by the Presenter and it _delegates_ user interaction actions to the Presenter. Ideally it contains no business logic, only view logic.
* **Interactor**: used for fetching data when requested by the Presenter, regardless of where the data is coming from. Contains only business logic.
* **Presenter**: prepares the content which it receives from the Interactor to be presented by the View. Contains business and view logic - basically it connects the two.
* **Entity**: models which are handled by the Interactor. Contains only business logic, but primarily data, not rules.
* **Router**: handles navigation logic. In our case we use components called Wireframes for this responsibility.

## Components
Your entire app is made up of multiple modules which you organize in logical groups and use one storyboard for that group. In most cases the modules will represent screens and your module groups will represent user-stories, business-flows and so on.

Module components:

* **View**
* **Presenter**
* **Interactor** (not mandatory)
* **Wireframe**

In some simpler cases you won't need an Interactor for a certain module, which is why this component is not mandatory. These are cases where you don't need to fetch any data, which is usually not common.

Wireframes inherit from the BaseWireframe. Presenters and Interactors do not inherit any class. Views most often inherit UIViewControllers. All protocols should be located in one file called *Interfaces*. More on this later.

## Communication and references
The following pictures shows relationships and communication for one module.

![iOS VIPER GRAPH](/Images/ios_viper_graph.jpg "iOS VIPER GRAPH")

Let's take a look at the communication logic.

* *LoginViewController* communicates with *LoginPresenter* via a *LoginPresenterInterface* protocol
* *LoginPresenter* communicates with *LoginViewController* via a *LoginViewInterface* protocol
* *LoginPresenter* communicates with *LoginInteractor* via a *LoginInteractorInterface* protocol
* *LoginPresenter* communicates with *LoginWireframe* via a *LoginWireframeInterface* protocol

The communication between most components of a module is done via protocols to ensure scoping of concerns and testability. Only the Wireframe communicates directly with the Presenter since it actually instantiates the Presenter, Interactor and View and connects the three via dependency injection.

Now let's take a look at the references logic.

* *LoginPresenter* has a **strong** reference to *LoginInteractor*
* *LoginPresenter* has a **strong** reference to *LoginWireframe*
* *LoginPresenter* has a **unowned** reference to *LoginViewController*
* *LoginViewController* has a **strong** reference to *LoginPresenter*


The reference types might appear a bit counter-intuitive, but they are organized this way to assure all module components are not deallocated from memory as long as one of its Views is active. In this way the Views lifecycle is also the lifecycle of the module - which actually makes perfect sense.

The creation and setup of module components is done in the Wireframe. The creation of a new Wireframe is almost always done in the previous Wireframe. More details on this later in the actual code.

Before we go into detail we should comment one somewhat unusual decision we made naming-wise and that's suffixing protocol names with "Interface" (*LoginWireframeInterface*, *RegisterViewInterface*, ...). A common way to do this would be to omit the "Interface" part but we've found that this makes code somewhat less readable and the logic behind VIPER harder to grasp, especially when starting out.

## 1. Base classes and interfaces

The module generator tool will generate five files - but in order for these to work you will need a couple of base protocols and classes. These are also available in the repo.
Let's start by covering these base files: *WireframeInterface*, *BaseWireframe*, *ViewInterface*, *InteractorInterface*, *PresenterInterface*, *UIStoryboardExtension*:

### WireframeInterface and BaseWireframe

```swift
protocol WireframeInterface: class {
}

class BaseWireframe {

    private unowned var _viewController: UIViewController
    
    //to retain view controller reference upon first access
    private var _temporaryStoredViewController: UIViewController?

    init(viewController: UIViewController) {
        _temporaryStoredViewController = viewController
        _viewController = viewController
    }

}

extension BaseWireframe: WireframeInterface {
    
}

extension BaseWireframe {
    
    var viewController: UIViewController {
        defer { _temporaryStoredViewController = nil }
        return _viewController
    }
    
    var navigationController: UINavigationController? {
        return viewController.navigationController
    }
    
}

extension UIViewController {
    
    func presentWireframe(_ wireframe: BaseWireframe, animated: Bool = true, completion: (()->())? = nil) {
        present(wireframe.viewController, animated: animated, completion: completion)
    }
    
}

extension UINavigationController {
    
    func pushWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        self.pushViewController(wireframe.viewController, animated: animated)
    }
    
    func setRootWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        self.setViewControllers([wireframe.viewController], animated: animated)
    }
    
}

extension BaseWireframe: WireframeInterface {
}
```
The Wireframe is used in 2 steps:

1. Initialization using a *UIViewController* (see the *init* method). Since the Wireframe is in charge of performing the navigation it needs access to the actual *UIViewController* with which it will do so.
2. Navigation to a screen (see the *pushWireframe*, *presentWireframe* and *setRootWireframe* methods).
Those metods are defined on *UIViewController* and *UINavigationController* since those objects are responsible for performing the navigation.

### PresenterInterface

```swift
protocol PresenterInterface: class {
    func viewDidLoad()
    func viewWillAppear(animated: Bool)
    func viewDidAppear(animated: Bool)
    func viewWillDisappear(animated: Bool)
    func viewDidDisappear(animated: Bool)
}

extension PresenterInterface {

    func viewDidLoad() {
        fatalError("Implementation pending...")
    }

    func viewWillAppear(animated: Bool) {
        fatalError("Implementation pending...")
    }

    func viewDidAppear(animated: Bool) {
        fatalError("Implementation pending...")
    }

    func viewWillDisappear(animated: Bool) {
        fatalError("Implementation pending...")
    }

    func viewDidDisappear(animated: Bool) {
        fatalError("Implementation pending...")
    }
}
```
The *PresenterInterface* offers only optional methods which are used for the Presenter to performa tasks based on View events. For methods you use without implementing them you'll get a nice big fatal error.

### ViewInterface and InteractorInterface
```swift
protocol ViewInterface: class {
}

extension ViewInterface {
}
```
```swift
protocol InteractorInterface: class {
}

extension InteractorInterface {
}
```

These two interfaces are initially empty. They exists just to make it simple to insert any and all functions needed in all views/interactors in you project. Both protocols need to be class bound because the Presenter will hold them via a weak reference.

Ok, let's get to the actual module. First we'll cover the files you get when creating a new module via the module generator.

## 2. What you get when generating a module
When running the module generator you will get five files. Say we wanted to create a Login module, we would get the following: *LoginInterfaces*, *LoginWireframe*, *LoginPresenter*, *LoginView* and *LoginInteractor*. Let's go over all five.

### Interfaces

```swift
enum LoginNavigationOption {
}

protocol LoginWireframeInterface: WireframeInterface {
    func navigate(to option: LoginNavigationOption)
}

protocol LoginViewInterface: ViewInterface {
}

protocol LoginPresenterInterface: PresenterInterface {
}

protocol LoginInteractorInterface: InteractorInterface {
}
```

This interface file will provide you with a nice overview of your entire module at one place. Since most components communicate with each other via protocols we found very useful to put all of these protocols for one module in one place. That way you have a very clean overview of the entire behavior of the module.
The *LoginNavigationOption* enum is used for all navigation actions which involve creating a new wireframe and navigating to it in which ever way possible. This will become clearer when we go over a concrete example.

### Wireframe

```swift
final class LoginWireframe: BaseWireframe {

    // MARK: - Private properties -

    private let _storyboard = UIStoryboard(name: <#Storyboard name#>, bundle: nil)

    // MARK: - Module setup -

    init() {
        let moduleViewController = _storyboard.instantiateViewController(ofType: LoginViewController.self)
        super.init(viewController: moduleViewController)
        
        let interactor = LoginInteractor()
        let presenter = LoginPresenter(wireframe: self, view: moduleViewController, interactor: interactor)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension LoginWireframe: LoginWireframeInterface {

    func navigate(to option: LoginNavigationOption) {
    }
}
```
If you've created a storyboard which contains a *LoginViewController*, all you need to do is enter the storyboard name (see *_storyboard* var) here and the code will compile. We've made the assumption that you use the class name for an identifier but you can of course change this at any point in the future.


### Presenter

```swift
final class LoginPresenter {

    // MARK: - Private properties -

    private unowned let _view: LoginViewInterface
    private let _interactor: LoginInteractorInterface
    private let _wireframe: LoginWireframeInterface

    // MARK: - Lifecycle -

    init(wireframe: LoginWireframeInterface, view: LoginViewInterface, interactor: LoginInteractorInterface) {
        _wireframe = wireframe
        _view = view
        _interactor = interactor
    }
}

// MARK: - Extensions -

extension LoginPresenter: LoginPresenterInterface {
}
```
This is the skeleton of a Presenter which will get a lot more meat on it once you start implementing the business logic.

### View

```swift
final class LoginViewController: UIViewController {

	// MARK: - Public properties -

    var presenter: LoginPresenterInterface!

    // MARK: - Life cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: - Extensions -

extension LoginViewController: LoginViewInterface {
}
```
Like the Presenter above, this is only a skeleton which you will populate with IBOutlets, animations and so on.

### Interactor

```swift
final class LoginInteractor {
}

extension LoginInteractor: LoginInteractorInterface {
}
```
When generated your Interactor is also a skeleton which you will in most cases use to perform fetching of data from remote API services, Database services, etc.

## 3. How it really works
Here's an example of a wireframe for a Login screen which uses two types of navigation to navigate to a login and registration screen. Let's start with the Presenter

```swift
final class LoginPresenter {

    // MARK: - Private properties -
    static private let minimumPasswordLength: UInt = 6

    private unowned let _view: LoginViewInterface
    private let _interactor: LoginInteractorInterface
    private let _wireframe: LoginWireframeInterface

    private let _authorizationManager = AuthorizationAdapter.shared
    private let _emailValidator = EmailValidator()
    private let _passwordValidator = PasswordValidator(
        minLength: LoginPresenter.minimumPasswordLength
    )

    // MARK: - Lifecycle -
    init (wireframe: LoginWireframeInterface, view: LoginViewInterface, interactor: LoginInteractorInterface) {
        _wireframe = wireframe
        _view = view
        _interactor = interactor
    }

}

// MARK: - Extensions -
extension LoginPresenter: LoginPresenterInterface {

    func didSelectLoginAction(with email: String?, password: String?) {
        guard let _email = email, let _password = password else {
            _showLoginValidationError()
            return
        }
        guard _emailValidator.isValid(_email) else {
            _showEmailValidationError()
            return
        }
        guard _passwordValidator.isValid(_password) else {
            _showPasswordValidationError()
            return
        }

        _view.showProgressHUD()
        _interactor.loginUser(with: _email, password: _password) { [weak self] (response) in
            self?._view?.hideProgressHUD()
            self?._handleLoginResult(response.result)
        }
    }
}

private extension LoginPresenter {
    
    func _handleLoginResult(_ result: Result< JSONAPIObject<User> >) {
        switch result {
        case .success(let jsonObject):
            _authorizationManager.authorizationHeader = jsonObject.object.authorizationHeader
            _wireframe.navigate(to: .home)

        case .failure(let error):
            _wireframe.showErrorAlert(with: error.message)
        }
    }

    func _showLoginValidationError() {
        _wireframe.showAlert(with: "Error", message: "Please enter email and password")
    }

    func _showEmailValidationError() {
        _wireframe.showAlert(with: "Error", message: "Please enter valid email")
    }

    func _showPasswordValidationError() {
        _wireframe.showAlert(with: "Error", message: "Password should be at least 6 characters long")
    }
}
```
In this simple example the Presenter handles a login action selection which is delegated from the View. After that some validation is performed and then the actual login is performed using the Interactor. In the event of a successful login a navigation to a home screen is initiated. Let's take a look at the Wireframe in this example for a bit more clarity.

```swift
final class LoginWireframe: BaseWireframe {

    // MARK: - Private properties -

    private let _storyboard = UIStoryboard(name: "Login", bundle: nil)

    // MARK: - Module setup -

    init() {
        let moduleViewController = _storyboard.instantiateViewController(ofType: LoginViewController.self)
        super.init(viewController: moduleViewController)
        
        let interactor = LoginInteractor()
        let presenter = LoginPresenter(wireframe: self, view: moduleViewController, interactor: interactor)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -
extension LoginWireframe: LoginWireframeInterface {

    func navigate(to option: LoginNavigationOption) {
        switch option {
        case .home:
            navigationController?.setRootWireframe(HomeWireframe())
        }
    }
}
```

This is also a simple example of a wireframe which handles only one type of navigation. You've maybe notices the *showAlert* Wireframe method used in the Presenter to display alerts. This is used in the BaseWireframe in this concrete project and looks like this:

```swift
func showAlert(with title: String?, message: String?) {
	let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
	showAlert(with: title, message: message, actions: [okAction])
}
```
This is just one example of some shared logic you'll want to put in your base class or maybe one of the base protocols.

This was just a short example of how one module can come together. Soon we'll make an entire example project available on GitHub which will contain much more use cases.

## How it's organized in Xcode

Using this architecture impacted the way we organize our projects. In most cases we have four main subfolders in the project folder: Application, Common, Modules and Resources. Let's go over those a bit.

### Application
Contains AppDelegate and any other app-wide components, initializers, appearance classes, managers and so on. Usually this folder contains only a few files.

### Common
Used for all common utility and view components grouped in sub folders. Some common cases for these groups are _Analytics_, _Constants_, _Extensions_, _Protocols_, _Views_, _Networking_, etc. Also here is where we always have a _VIPER_ subfolder which contains the base VIPER protocols and classes.

### Resources
This folder should contain image assets, fonts, audio and video files, and so on. We use one *.xcassets* for images and in that folder separate images into logical folders so we don't get a long list of files in one place.

### Modules
As described earlier you can think of one VIPER module as one screen. In the _Modules_ folder we organize screens into logical groups which are basically user-stories. Each group is organized in a subfolder which contains one storyboard (containing all screens for that group) and multiple module subfolders.

![iOS VIPER MODULES](/Images/ios_viper_modules.png "iOS VIPER MODULES")


## Useful links

* https://techblog.badoo.com/blog/2016/03/21/ios-architecture-patterns/
* https://www.objc.io/issues/13-architecture/viper/
* https://swifting.io/blog/2016/03/07/8-viper-to-be-or-not-to-be/

## Contributing

Feedback and code contributions are very much welcome. Just make a pull request with a short description of your changes. By making contributions to this project you give permission for your code to be used under the same [license](License).

## Credits

Maintained and sponsored by
[Infinum](http://www.infinum.co).

<img src="https://infinum.co/infinum.png" width="264">
