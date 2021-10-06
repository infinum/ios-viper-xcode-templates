# VIPER RxModule Guide

**For the installation guide and basic information about VIPER read the [Readme](https://github.com/infinum/iOS-VIPER-Xcode-Templates#readme)**

## 1. Generated classes and interfaces

The module generator tool will generate five files, the same as the non-rx module. However, there is an option to generate a Formatter which will be covered in a separate guide. All the files shown will be available in the demo project.
We will generate "Login" (you can set whichever name you want) files and cover them as they are generated in xCode: *LoginInterfaces*, *LoginPresenter*, *LoginViewController*, *LoginInteractor* and *LoginWireframe*.

###LoginInterfaces

```swift
protocol LoginWireframeInterface: WireframeInterface {
}

protocol LoginViewInterface: ViewInterface {
}

protocol LoginPresenterInterface: PresenterInterface {
    func configure(with output: Login.ViewOutput) -> Login.ViewInput
}

protocol LoginInteractorInterface: InteractorInterface {
}

enum Login {

    struct ViewOutput {
    }

    struct ViewInput {
    }

}
```

Interfaces file generates interfaces for our wireframe, view, presenter and interactor. These interfaces let us encapsulate whichever code we don't to be visible by the other side. The generated file contains one function in <i>LoginPresenterInterface</p> which initializes the communication between our Presenter and ViewController. As a parameter it requires *ViewOutput* and returns *ViewInput*. Firstly, we got an enum called *Login* which is generated for us. The enum contains two structures, one for output, one for input. As the name suggests, <i>ViewOutput</i> is used to store every piece of information that our view wants presenter to know about. Same principle but the other way around is <i>ViewInput</i>, our presenter sends information to the view which it can observe and react to.

###LoginPresenter

```swift
final class LoginPresenter {

    // MARK: - Private properties -

    private unowned let view: LoginViewInterface
    private let interactor: LoginInteractorInterface
    private let wireframe: LoginWireframeInterface

    // MARK: - Lifecycle -

    init(
        view: LoginViewInterface,
        interactor: LoginInteractorInterface,
        wireframe: LoginWireframeInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension LoginPresenter: LoginPresenterInterface {

    func configure(with output: Login.ViewOutput) -> Login.ViewInput {
        return Login.ViewInput()
    }

}
```

The generated presenter file conforms to the Presenter interface shown earlier. Presenter doesn't come with a DisposeBag, but if it is needed, you can freely add it. Every bit of magic happens in the configure function from the interface. Presenter gets every piece of information from the view through the *ViewOutput* struct and it can subscribe to those events and react to them as needed (API calls, business logic, etc.). Since <i>configure</i> method defines a two-way communication between presenter and the view (or two-way binding if you like), after we initialise subscriptions from the view's output, we can return some input to the view if view needs to react to it. Later on, we will explain how it looks on the view side.

###LoginViewController

```swift
final class LoginViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: LoginPresenterInterface!

    // MARK: - Private properties -

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

// MARK: - Extensions -

extension LoginViewController: LoginViewInterface {
}

private extension LoginViewController {

    func setupView() {
        let output = Login.ViewOutput()

        let input = presenter.configure(with: output)
    }

}
```

The generated viewController file is mostly the same as the basic one, but there is a key difference in the <i>setupView</i> function where you create the *ViewInput* and call the <i>configure</i> function from presenter. As it was explained earlier, the presenter's <i>configure</i> method defines the two-way binding and it returns every important bit of information that is consumed by the view. Without this information our viewController wouldn't be functional, it has to subscribe to that information and use it as it is required (disable buttons, etc.).


###LoginInteractor and LoginWireframe

```swift
final class LoginInteractor {
}

// MARK: - Extensions -

extension LoginInteractor: LoginInteractorInterface {
}
```

```swift
final class LoginWireframe: BaseWireframe<LoginViewController> {

    // MARK: - Private properties -
    private let storyboard = UIStoryboard(name: "Login", bundle: nil)
    // MARK: - Module setup -

    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: LoginViewController.self)
        super.init(viewController: moduleViewController)

        let interactor = LoginInteractor()
        let presenter = LoginPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension LoginWireframe: LoginWireframeInterface {
}
```

The generated interactor and wireframe files are the same as basic ones. If you need some explanation about how they work visit the main [Readme](https://github.com/infinum/iOS-VIPER-Xcode-Templates#readme).

## 2. How to actually use it?

As you might have noticed before, we have ended up with an example of Login. We're going to show you how to implement a simple login screen with *Viper RxModule*. We'll cover classes in the same order respectively. Firstly, *LoginInterfaces*

###LoginInterfaces

```swift
protocol LoginWireframeInterface: WireframeInterface {
    func navigateToHome()
}

protocol LoginViewInterface: ViewInterface {
}

protocol LoginPresenterInterface: PresenterInterface {
    func configure(with output: Login.ViewOutput) -> Login.ViewInput
}

protocol LoginInteractorInterface: InteractorInterface {
    func login(with email: String, _ password: String) -> Single<User>
    func register(with email: String, _ password: String) -> Single<User>
    func rememberUser()
}

enum Login {

    struct ViewOutput {
        let actions: LoginActions
    }

    struct ViewInput {
        let events: LoginEvents
    }

}


struct LoginActions {
    let rememberMe: Driver<Bool>
    let login: Signal<Void>
    let register: Signal<Void>
    let email: Driver<String?>
    let password: Driver<String?>
}

struct LoginEvents {
    let areActionsAvailable: Driver<Bool>
}
```

As you're reading through the implemented interfaces file, you might have noticed the <i>navigateToHome</i> function but I believe it's quite self-explanatory. Handles the navigation to the <i>Home</i> screen.

Next in order is login function in the LoginInteractorInterface which differs from the standard one (non-rx) in returning the observable sequence (in this case its Single trait) instead of receiving the completion handler as a method argument. The same goes for the <i>register</i> method. We try to use traits as much as possible and when they are applicable. Don't overuse them, try to understand when and where you should use them. We mostly use Single and Completable as return types when defining API calls since in that case it is expected to either succeed or fail with returned value/error, or when the API call does not return anything (or the result does not matter), use Completable. We'll get in touch with <i>rememberUser</i> function in the *LoginInteractor* part of this guide.

Lastly, we're moving to the Login enum which now contains some information. As you can see, we have added *LoginActions* struct which helps us organise actions in one single place. Actions will hold every driver, signal, etc. which the view wants to pass to Presenter. We're mostly using Drivers for use cases where we need to access the last known value when subscribing, for example when binding a value to the text field. On the other hand, we use signals to register button taps or anything which just needs to say that it has happened and doesn't need to keep the last known value. As those are actions, you want to name them as actions (login, register, email, rememberMe, etc.) and not as emailDriver, etc. When Presenter wants to send something to the view, we wrap it in *Events* struct which contains every possible event which view needs to know about. With events, for example, there can be an items property that will contain items that are shown on the screen (tableView, collectionView). Events work just like actions and naming is not any different :)

Having that said, we have wrapped up a big chunk of information. We have covered how to pass information from the view to the presenter and back. Now let's see how it works under the hood. *LoginPresenter* here we come!

###LoginPresenter

```swift
final class LoginPresenter {

    // MARK: - Private properties -

    private unowned let view: LoginViewInterface
    private let interactor: LoginInteractorInterface
    private let wireframe: LoginWireframeInterface

    private let emailValidator: EmailValidator
    private let passwordValidator: PasswordValidator
    private let disposeBag: DisposeBag

    // MARK: - Lifecycle -

    init(
        view: LoginViewInterface,
        interactor: LoginInteractorInterface,
        wireframe: LoginWireframeInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe

        emailValidator = EmailValidator()
        passwordValidator = PasswordValidator(minLength: 6)
        disposeBag = DisposeBag()
    }
}

// MARK: - Extensions -

extension LoginPresenter: LoginPresenterInterface {

    func configure(with output: Login.ViewOutput) -> Login.ViewInput {
        handle(
            login: output.actions.login,
            output.actions.email,
            output.actions.password,
            remember: output.actions.rememberMe
        )
        handle(
            register: output.actions.register,
            output.actions.email,
            output.actions.password,
            remember: output.actions.rememberMe
        )

        return Login.ViewInput(events: LoginEvents(
            areActionsAvailable: handle(inputs: (email: output.actions.email, password: output.actions.password))
        ))
    }

}

private extension LoginPresenter {
    func handle(
        login: Signal<Void>,
        _ email: Driver<String?>,
        _ password: Driver<String?>,
        remember: Driver<Bool>
    ) {
        let inputs = Driver.combineLatest(email.compactMap { $0 }, password.compactMap { $0 })
        login
            .withLatestFrom(inputs)
            .flatMap { [unowned self] email, password -> Driver<User> in
                return performLogin(email, password)
            }
            .withLatestFrom(remember) { ($0, $1) }
            .do(onNext: { [unowned self] user, remember in
                saveUser(remember, user)
                view.hideProgressHUD()
            })
            .drive(onNext: { [unowned wireframe] _ in
                wireframe.navigateToHome()
            })
            .disposed(by: disposeBag)
    }

    func performLogin(_ email: String, _ password: String) -> Driver<User> {
        return interactor
            .login(with: email, password)
            .do(onError: { [unowned self] error in
                view.hideProgressHUD()
                showValidationError(error)
            }, onSubscribe: { [unowned view] in
                view.showProgressHUD()
            })
            .asDriver(onErrorDriveWith: .never())
    }

    func handle(
        register: Signal<Void>,
        _ email: Driver<String?>,
        _ password: Driver<String?>,
        remember: Driver<Bool>
    ) {
        let inputs = Driver.combineLatest(email.compactMap { $0 }, password.compactMap { $0 })
        register
            .withLatestFrom(inputs)
            .flatMap { [unowned self] email, password -> Driver<User> in
                return performRegister(email, password)
            }
            .withLatestFrom(remember) { ($0, $1) }
            .do(onNext: { [unowned self] user, remember in
                saveUser(remember, user)
                view.hideProgressHUD()
            })
            .drive(onNext: { [unowned wireframe] _ in
                wireframe.navigateToHome()
            })
            .disposed(by: disposeBag)
    }

    func performRegister(_ email: String, _ password: String) -> Driver<User> {
        return interactor
            .register(with: email, password)
            .do(onError: { [unowned self] error in
                view.hideProgressHUD()
                showValidationError(error)
            }, onSubscribe: { [unowned view] in
                view.showProgressHUD()
            })
            .asDriver(onErrorDriveWith: .never())
    }

    func handle(inputs: (email: Driver<String?>, password: Driver<String?>)) -> Driver<Bool> {
        Driver.combineLatest(inputs.email.compactMap { $0 }, inputs.password.compactMap { $0 })
            .map { [unowned self] email, password in
                return isEmailValid(email) && isPasswordValid(password)
            }
            .startWith(false)
    }

    func isEmailValid(_ email: String) -> Bool {
        return emailValidator.isValid(email)
    }

    func isPasswordValid(_ password: String) -> Bool {
        return passwordValidator.isValid(password)
    }


    func saveUser(_ shouldSave: Bool, _ user: User) {
        if shouldSave {
            interactor.rememberUser()
        }
    }
}

private extension LoginPresenter {
    func showValidationError(_ error: Error) {
        wireframe.showAlert(with: "Error", message: error.localizedDescription)
    }
}
```

Whoa! That was a lot of code. Don't fret, it's quite simple :)

We'll start from the top. We have implemented some part of validation for the email and password just so we can enable/disable our buttons. Now we're going straight down to the <i>configure</i> function. Inside the <i>configure</i> method presenter registers to the events from the *ViewOutput*. As there is a driver which we'll send to the view, we have to call <i>handle(inputs:)</i> function and pass it as a parameter. We'll take both, email and password drivers, do some Rx magic which will check if the inputs are valid, and return a fresh driver with a bool value. If the inputs are valid it returns true, and as the name of the driver says, buttons will be available, otherwise, they are disabled. Every <i>handle</i> function has a different purpose and requires different parameters. There are <i>handle(login...)</i> and <i>handle(register...)</i> and we differ their functionality by the first parameter.

After presenter creates inputs for the view, we want the presenter to subscribe to the actions that are performed by the view. Since those actions only result in navigation or API call, we don't have to return anything, just handle the navigation/calls internally.
Next, we'll get in touch with our implemented *LoginViewController*.

###LoginViewController

```swift
final class LoginViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: LoginPresenterInterface!

    // MARK: - Private properties -

    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var checkboxButton: UIButton!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var registerButton: UIButton!
    @IBOutlet var secureEntryButton: UIButton!
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

// MARK: - Extensions -

extension LoginViewController: LoginViewInterface {
}

private extension LoginViewController {

    func setupView() {
        let remember = checkboxButton.rx.tap.asDriver()
            .scan(false) { previousValue, _ in
                !previousValue
            }

        let output = Login.ViewOutput(actions: LoginActions(
            rememberMe: remember,
            login: loginButton.rx.tap.asSignal(),
            register: registerButton.rx.tap.asSignal(),
            email: emailTextField.rx.text.asDriver(),
            password: passwordTextField.rx.text.asDriver()
        ))

        let input = presenter.configure(with: output)
        handle(rememberMe: remember)
        handle(areActionsAvailable: input.events.areActionsAvailable)
        handle(secureEntry: secureEntryButton.rx.tap.asDriver())
    }

}

private extension LoginViewController {
    func handle(rememberMe: Driver<Bool>) {
        rememberMe
            .drive(checkboxButton.rx.isSelected)
            .disposed(by: disposeBag)
    }

    func handle(areActionsAvailable: Driver<Bool>) {
        areActionsAvailable
            .drive(registerButton.rx.isEnabled)
            .disposed(by: disposeBag)

        areActionsAvailable
            .map { $0 ? 1 : 0.3 }
            .drive(registerButton.rx.alpha)
            .disposed(by: disposeBag)

        areActionsAvailable
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)

        areActionsAvailable
            .map { $0 ? 1 : 0.3 }
            .drive(loginButton.rx.alpha)
            .disposed(by: disposeBag)
    }

    func handle(secureEntry: Driver<Void>) {
        let state = secureEntry
            .scan(true) { previousValue, _ in
                !previousValue
            }

        state
            .drive(secureEntryButton.rx.isSelected)
            .disposed(by: disposeBag)

        state
            .drive(passwordTextField.rx.isSecureTextEntry)
            .disposed(by: disposeBag)
    }
}
```

We'll just explain the <i>setupView</i> function since it's the main part.

As you can see, our <i>setupView</i> function is quite small since we're trying to use SRP as much as possible to separate our code into smaller functions which are then called by the main one. It's purpose is to initialize the *ViewOutput* and *ViewInput*. We have passed everything from our *IBOutlets* as parameters for the *ViewOutput* which will be used in the presenter. The presenter is good enough to give us some information back about the availability of our actions. After the presenter has been configured and we have got our *ViewInput* structure, we can react to the events as needed. In our case, we have reacted by changing the alpha of the buttons and driving the bool value into the <i>isEnabled</i> property of the same ones.

Hopefully, that wasn't hard for you to cope, hold on a bit longer, we're close to the end :)
Let's move onto the *LoginInteractor*:

###LoginInteractor

```swift
final class LoginInteractor {
    let userService: UserService

    init(userService: UserService = .shared) {
        self.userService = userService
    }
}

// MARK: - Extensions -

extension LoginInteractor: LoginInteractorInterface {
    func login(with email: String, _ password: String) -> Single<User> {
        userService.login(with: email, password)
    }

    func register(with email: String, _ password: String) -> Single<User> {
        userService.register(with: email, password)
    }

    func rememberUser() {
        userService.rememberUser()
    }

}
```

The interactor, as in base module, helps us make API calls or any other call that we need. It contains a service as a property which has to know how to handle Interactor functions. In this case, our *UserService* knows how to log in, register and save a user so he doesn't have to log in every time he opens the application. We try to inject everything that we can to keep up with the SOLID principles and keep our code cleaner :)

Last but not the least, *LoginWireframe*:

###LoginWireframe

```swift
final class LoginWireframe: BaseWireframe<LoginViewController> {

    // MARK: - Private properties -

    private let storyboard = UIStoryboard(name: "Login", bundle: nil)

    // MARK: - Module setup -

    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: LoginViewController.self)
        super.init(viewController: moduleViewController)

        let interactor = LoginInteractor()
        let presenter = LoginPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension LoginWireframe: LoginWireframeInterface {
    func navigateToHome() {
        //needs implementation when home is created
    }
}
```

There isn't anything special going on here, that is specific for the RxModule. It's just handling the navigation from the Login to Home screen.

This here just shows you how you can implement on a simple example, it can get much more complicated than this by using a Formatter or just a bigger Presenter and ViewController. The sole purpose of this example is to show you the tools and how you can prospect when using them. Hopefully, this wasn't too hard for you, and that you managed to get a clearer picture in your head of how the *RxModule* works.

Cheers from the Infinum iOS team :)
