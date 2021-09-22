# VIPER RxModule Guide

**For the installation guide and basic information about VIPER read the <i>README.md</i>**

## 1. Generated classes and interfaces

The module generator tool will generate five files, the same as the non-rx module. However, there is an option to generate a formatter which will be covered in a separate guide. All the files shown will be available in the demo project.
We will generate "RxLogin" (you can set whichever name you want) files and cover them as they are generated in xCode: *RxLoginInterfaces*, *RxLoginPresenter*, *RxLoginViewController*, *RxLoginInteractor* and *RxLoginWireframe*.

###RxLoginInterfaces

```swift
protocol RxLoginWireframeInterface: WireframeInterface {
}

protocol RxLoginViewInterface: ViewInterface {
}

protocol RxLoginPresenterInterface: PresenterInterface {
    func configure(with output: RxLogin.ViewOutput) -> RxLogin.ViewInput
}

protocol RxLoginInteractorInterface: InteractorInterface {
}

enum RxLogin {

    struct ViewOutput {
    }

    struct ViewInput {
    }

}
```

Itrefaces file generates interfaces for our wireframe, view, presenter and interactor. These interfaces let us encapsulate whichever code we don't to be visible by the other side. The generated file contains one function in <i>RxLoginPresenterInterface</p> which initializes the communication between our presenter and viewController. As a parameter it requires *ViewOutput* and returns *ViewInput*. Firstly, we got an enum called *RxLogin* which is generated for us. The enum contains two structures, one for output, one for input. As the name suggests, <i>ViewOutput</i> is used to store every piece of information that our view wants presenter to know about. Same principle but the other way around is <i>ViewInput</i>, our presenter sends information to the view which he can observe and react to.

###RxLoginPresenter

```swift
final class RxLoginPresenter {

    // MARK: - Private properties -

    private unowned let view: RxLoginViewInterface
    private let interactor: RxLoginInteractorInterface
    private let wireframe: RxLoginWireframeInterface

    // MARK: - Lifecycle -

    init(
        view: RxLoginViewInterface,
        interactor: RxLoginInteractorInterface,
        wireframe: RxLoginWireframeInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension RxLoginPresenter: RxLoginPresenterInterface {

    func configure(with output: RxLogin.ViewOutput) -> RxLogin.ViewInput {
        return RxLogin.ViewInput()
    }

}
```

The generated presenter file conforms to presenter interface shown earlier. Presenter doesn't come with a DisposeBag, but if it is needed, you can freely add it. Every bit of magic happens in the configure function from the interface. Presenter gets every piece of information from the view through the *.ViewOutput* struct and we can subscribe to those events and react to them as needed ( API calls, business logic, etc. ). Since this is a two way communication in <i>configure</i> function, after we initialize subscriptions from the output, we can return something to the view if it is needed. Later on we will explain how it looks on the other side of the communication.

###RxLoginViewController

```swift
final class RxLoginViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: RxLoginPresenterInterface!

    // MARK: - Private properties -

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

// MARK: - Extensions -

extension RxLoginViewController: RxLoginViewInterface {
}

private extension RxLoginViewController {

    func setupView() {
        let output = RxLogin.ViewOutput()

        let input = presenter.configure(with: output)
    }

}
```

The generated viewController files is mostly the same as the basic one, but there is a key difference in the <i>setupView</i> function where you create the *ViewInput* and call the <i>configure</i> function from presenter. As it was explained earlier, the presenter's <i>configure</i> function is a two way communication and it returns every important bit of information without which our viewController wouldn't be functional. We have to subscribe to that information and use it as it is required ( disable buttons, etc. ).


###RxLoginInteractor and RxLoginWireframe

```swift
final class RxLoginInteractor {
}

// MARK: - Extensions -

extension RxLoginInteractor: RxLoginInteractorInterface {
}
```

```swift
final class RxLoginWireframe: BaseWireframe<RxLoginViewController> {

    // MARK: - Private properties -
    private let storyboard = UIStoryboard(name: "RxLogin", bundle: nil)
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

extension RxLoginWireframe: RxLoginWireframeInterface {
}
```

The generated interactor and wireframe files are the same as basic ones. If you need some explanation about how they work visit the main *README.md* file.

## 2. How to actually use it?

As you might have noticed before, we have ended up with an example of Login. We're going to show you how to implement a simple login screen with *Viper RxModule*. We'll cover classes in the same order respectively. Firstly, *RxLoginInterfaces*

###RxLoginInterfaces

```swift
enum LoginNavigationOption {
    case home
    case register
}

protocol RxLoginWireframeInterface: WireframeInterface {
    func navigate(to option: LoginNavigationOption)
}

protocol RxLoginViewInterface: ViewInterface {
}

protocol RxLoginPresenterInterface: PresenterInterface {
    func configure(with output: RxLogin.ViewOutput) -> RxLogin.ViewInput
}

protocol RxLoginInteractorInterface: InteractorInterface {
    func login(with email: String, _ password: String) -> Single<User>
}

enum RxLogin {

    struct ViewOutput {
        let actions: RxLoginActions
    }

    struct ViewInput {
        let events: RxLoginEvents
    }

}

struct RxLoginActions {
    let email: Driver<String?>
    let password: Driver<String?>
    let login: Signal<Void>
    let register: Signal<Void>
}

struct RxLoginEvents {
    let buttonAvailability: Driver<Bool>
}
```

As you're reading through the implemented interfaces file, you might have noticed the *LoginNavigationOption* enum. It's sole purpose, as it's name reveals, is to contain every navigation case. It helps us to navigate from presenter and allows us to maintain a cleaner code structure. The navigation function is declared in the *RxLoginWireframeInterface* so we can access it from the presenter. Logic on how to navigate is set in the wireframe.
Next in order, <i>login</i> function in the *RxLoginInteractorInterface* which differs from non-rx by not taking a closure as a parameter and the return type. We try to use traits as much as possible and when they are applicable. Don't overuse them, try to understand when and where you should use them. We mostly use Single and Completable as return types from API calls since mostly you want it to succeed or fail, or in the completable case, you want it to complete.
Lastly, we're moving to the RxLogin enum which now contains some information. As you can see, we have added *RxLoginActions* struct which helps us organize actions in one single place. Actions will hold every driver, signal, etc. which the view wants to pass to presenter. We're mostly using drivers for textFields and interaction which has to have an option to access the previous value. On the other hand, we use signals to register button taps or anything which just needs to say that it has happened and doesn't need to keep the last known value. As those are actions, you want to name them as actions ( login, register, email, rememberMe, etc. ) and not as emailDriver, etc. When presenter wants to send something to the view, we wrap it in *Events* struct which contains every possible event which view needs to know about. Beside it, there can be an items property which will contain items that are shown on the screen (tableView, collectionView). Events work just like actions and naming is not any different :)
Having that said, we have wrapped up a big chunk of information. We have covered how to pass information from the view to the presenter and back. Now let's see how it works under the hood. *RxLoginPresenter* here we come!

###RxLoginPresenter

```swift
inal class RxLoginPresenter {

    // MARK: - Private properties -
    static private let minimumPasswordLength: UInt = 6

    private unowned let view: RxLoginViewInterface
    private let interactor: RxLoginInteractorInterface
    private let wireframe: RxLoginWireframeInterface

    private let emailValidator: StringValidator
    private let passwordValidator: StringValidator
    private let authorizationManager: AuthorizationAdapter

    private let disposeBag: DisposeBag
    // MARK: - Lifecycle -

    init(
        view: RxLoginViewInterface,
        interactor: RxLoginInteractorInterface,
        wireframe: RxLoginWireframeInterface,
        authorizationManager: AuthorizationAdapter = AuthorizationAdapter.shared
    ) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        self.authorizationManager = authorizationManager

        emailValidator = EmailValidator()
        passwordValidator = PasswordValidator(minLength: RxLoginPresenter.minimumPasswordLength)
        disposeBag = DisposeBag()
    }
}

// MARK: - Extensions -

extension RxLoginPresenter: RxLoginPresenterInterface {

    func configure(with output: RxLogin.ViewOutput) -> RxLogin.ViewInput {
        let inputs = initializeInputs(with: output.actions.email, output.actions.password)
        initializeLogin(
            with: output.actions.login,
            email: output.actions.email,
            password: output.actions.password
        )
        initializeRegister(with: output.actions.register)
        return RxLogin.ViewInput(events: RxLoginEvents(buttonAvailability: inputs))
    }

}

//MARK: - Private Extensions -

private extension RxLoginPresenter {

    func initializeInputs(with email: Driver<String?>, _ password: Driver<String?>) -> Driver<Bool> {

        Observable.combineLatest(
            email.asObservable().compactMap { $0 },
            password.asObservable().compactMap { $0 }
        )
            .map { [unowned self] email, password in
                isEmailValid(email) && isPasswordValid(password)
            }
            .asDriver(onErrorDriveWith: .never())
            .startWith(false)
    }

    func initializeLogin(with login: Signal<Void>, email: Driver<String?>, password: Driver<String?>) {

        let inputs = Driver.combineLatest(
            email.asObservable().compactMap { $0 }.asDriver(onErrorDriveWith: .empty()),
            password.asObservable().compactMap { $0 }.asDriver(onErrorDriveWith: .empty())
        )

        login
            .withLatestFrom(inputs)
            .flatMap { [unowned self] email, password -> Signal<User> in
                interactor.login(with: email, password)
                    .do(onError: { [unowned self] error in
                        view.hideProgressHUD()
                        wireframe.showErrorAlert(with: error.localizedDescription)
                    }, onSubscribe: { [unowned view] in
                        view.showProgressHUD()
                    })
                    .asSignal(onErrorSignalWith: .never())
            }
            .do(onNext: { [unowned self] user in
                authorizationManager.authorizationHeader = user.authorizationHeader
            })
            .emit(onNext: { [unowned wireframe] _ in
                wireframe.navigate(to: .home)
            })
            .disposed(by: disposeBag)
    }

    func isEmailValid(_ email: String) -> Bool {
        return emailValidator.isValid(email)
    }

    func isPasswordValid(_ password: String) -> Bool {
        return passwordValidator.isValid(password)
    }

    func initializeRegister(with register: Signal<Void>) {
        register
            .emit(onNext: { [unowned wireframe] in
                wireframe.navigate(to: .register)
            })
            .disposed(by: disposeBag)
    }
}
```

Whoa! That was a lot of code. Don't fret, it's quite simple :)
We'll start from top. As the base example we have implemented some part of validation for our email and password. Now we're going straight down to the <i>configure</i> function. In the <i>configure</i> function we have registered to the events from the *ViewOutput*. As there is a driver which we'll send to the view, we have to call <i>initializeInputs</i> function and pass it as a parameter. We'll take both, email and password drivers, do some Rx magic which will check if the inputs are valid and return a fresh driver with a bool value. If the inputs are valid it returns true, and as the name of the driver says, button will be available, otherwise, it's disabled.
After we have subscribed to our inputs, we want to subscribe to button taps. Since they only want to navigate or request an API call, we don't have to return anything from their initialization. That's why we sometimes need the disposeBag in presenter. That is mostly it about the Presenter, we use a lot of Rx a try to stay as pure with Rx as possible.
Next, we'll get in touch with our implemented *RxLoginViewController*.

###RxLoginViewController

```swift
final class RxLoginViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: RxLoginPresenterInterface!

    // MARK: - Private properties -
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var ballImageView: UIImageView!
    @IBOutlet private weak var stackViewBottomMargin: NSLayoutConstraint!

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle -

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        registerForKeyboardNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTapGesture()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - Extensions -

extension RxLoginViewController: RxLoginViewInterface {
}

private extension RxLoginViewController {

    func setupView() {
        let output = RxLogin.ViewOutput(actions: RxLoginActions(
            email: emailTextField.rx.text.asDriver(),
            password: passwordTextField.rx.text.asDriver(),
            login: loginButton.rx.tap.asSignal(),
            register: registerButton.rx.tap.asSignal())
        )

        let input = presenter.configure(with: output)
        initializeButtonAvailability(with: input.events.buttonAvailability)
    }

    func initializeButtonAvailability(with buttonAvailability: Driver<Bool>) {
        buttonAvailability
            .do(onNext: { [unowned self] buttonState in
                handleButtonState(for: loginButton, with: buttonState)
            })
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    func handleButtonState(for button: UIButton, with buttonState: Bool) {
        button.alpha = buttonState ? 1 : 0.3
    }

}

private extension RxLoginViewController {
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: .UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: .UIKeyboardWillHide,
            object: nil
        )
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height

        view.layoutIfNeeded()
        stackViewBottomMargin.constant = keyboardHeight
        view.setNeedsUpdateConstraints()

        UIView.animate(withDuration: 0.3) { [unowned self] in
            ballImageView.alpha = 0.0
            view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        view.layoutIfNeeded()
        stackViewBottomMargin.constant = 0
        view.setNeedsUpdateConstraints()

        UIView.animate(withDuration: 0.3) { [unowned self] in
            ballImageView.alpha = 1.0
            view.layoutIfNeeded()
        }
    }

    func setupTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGestureRecognizer)

        tapGestureRecognizer.rx.event
            .subscribe(onNext: { [unowned self] _ in
                view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
}
```

We'll just explain the <i>setupView</i> function since it's the main part. The last extension is only for keyboard dismissal.
As you can see, our <i>setupView</i> function is quite small. It's purpose is to initialize the *ViewOutput* and *ViewInput*. We have passed everything from our IBOutlets as parameters for the *ViewOutput* which will be used in the presenter. The presenter is good enough to give us some information back about the login button availability. After the presenter has been configured and we have got our *ViewInput* structure, we can react to the events as needed. In our case, we have reacted by changing the button alpha and driving the bool value into the loginButton.
Hopefully that wasn't hard for you to cope, hold on a bit longer, we're close to the end :)
Let's move onto the *RxLoginInteractor*:

###RxLoginInteractor

```swift
import Foundation
import RxSwift

final class RxLoginInteractor {

    private let userServiceable: UserServiceable

    init(userServiceable: UserServiceable = RxUserService.shared) {
        self.userServiceable = userServiceable
    }
}

// MARK: - Extensions -

extension RxLoginInteractor: RxLoginInteractorInterface {
    func login(with email: String, _ password: String) -> Single<User> {
        userServiceable.login(with: email, password)
    }

}
```

The interactor, as in base module, helps us make API calls or any other call that we need. It contains a protocol as a property which has to know how to handle our needed function. In this case, our *UserServiceable* knows how to login a user and that is it's main purpose. If we had the register functionality on the login screen, we'd add register to the *UserServiceable* protocol. The main reason why it's a protocol which a class has to implement is that it's much easier to test ( create mocks ) and even if it has to login in another way the Interactor doesn't need to know how you do it, just that you do it.
Last but not the least, *RxLoginWireframe*:

###RxLoginWireframe

```swift
final class RxLoginWireframe: BaseWireframe {

    // MARK: - Private properties -
    private let storyboard = UIStoryboard(name: "RxLogin", bundle: nil)
    // MARK: - Module setup -

    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: RxLoginViewController.self)
        super.init(viewController: moduleViewController)

        let interactor = RxLoginInteractor()
        let presenter = RxLoginPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension RxLoginWireframe: RxLoginWireframeInterface {
    func navigate(to option: LoginNavigationOption) {
        switch option {
        case .home:
            _openHome()
        case .register:
            _presentRegister()
        }

    }

    private func _openHome() {
        let wireframe = HomeWireframe()

        navigationController?.pushWireframe(wireframe)
    }

    private func _presentRegister() {
        let wireframe = RegisterWireframe()

        let wireframeNavigationController = PokedexNavigationController()
        wireframeNavigationController.setRootWireframe(wireframe)

        navigationController?.present(wireframeNavigationController, animated: true, completion: nil)

    }
}
```

There isn't anything special going on here, that is specific for the RxModule. It's just handling the navigation from the Login to home/register.

This here just shows you how you can implement on a simple example, it can get much more complicated than this by using a formatter or just bigger Presenter and ViewController. The sole purpose is to show you the tools and you can better yourself by using them. Hopefully this wasn't too hard for you and that you managed to get a clearer picture in your head on how the *RxModule* works.

Cheers from the Infinum iOS team :)
