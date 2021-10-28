# VIPER Formatter

*Disclaimer*
We will not be covering the basics of VIPER and RxVIPER architecture. Everything can be found in the main [Readme](https://github.com/infinum/iOS-VIPER-Xcode-Templates#readme).

## 1. What's a Formatter, why would I use it?

The first question you might ask yourself when glancing through our VIPER templates is what is a Formatter and why would I even use it? Let me help you answer that one :)

A Formatter is a class that helps us, as the name says, format information into something that we can use to updated the UI. But why would we have another class to handle it for us when we can do it in the presenter? Isn't Presenter the one who would do that for us? The answer is very simple, we just want our Presenter with fewer lines of code. If you ever worked on a bigger project, you might have found yourself in a situation where one class has over one thousand lines of code... We don't like that, it's very hard to maintain, and even if you try to make it as readable as possible, it's still too many lines of code. 

To achieve a much higher level of maintainability and readability, we remove the Presenter's formatting task and add the, already mentioned class, Formatter inside the Presenter. We only use the Formatter when there is a need for it, eg. we have a Presenter with 700 lines of code from which 400 are formatting functions. It's much easier to add a new class and have the formatting functionality in that class. After we have added the Formatter, we're left with a Presenter which doesn't know anything about how the information which he needs is created, only that he gets it and the Formatter's responsibility is to give it the needed information. We separate the responsibilities which is always a great result to have.

Another usage example would be when you reuse a screen and it needs different data to render. If the whole logic about formatting the information was inside the Presenter it would take too many lines of code. That's where the Formatter would jump into the rescue. Even if you had two different Formatters in a complex screen, it would help you out where you would just need to pay attention to which Formatter you need and when.


## 2. How do I create one?

Since you're at the VIPER templates Github, you might have guessed the answer to that one, we can generate it for you! :)

When we're trying to generate a module with Interactor + Formatter, we get the generated Formatter with other classes from that module. In this guide, we'll generate the Interactor + Formatter from RxModule since we're trying to use Rx as much as possible.

If you have any doubts about your understanding of the RxModule and which classes it generates for us, please visit the <i>[RxModule VIPER guide](Viper%20RxModule%20Guide.md)</i>. We'll go through the files which differ from the base RxModule with Interactor. Those are *Interfaces*, *Presenter*, *Wireframe*, and the star of the show *Formatter*. In this case, we'll generate a module named <i>Details</i>.

As you can see from the changed files, there's no *ViewController* and *Interactor*, they stay the same.

### Interfaces

```swift
protocol DetailsWireframeInterface: WireframeInterface {
}

protocol DetailsViewInterface: ViewInterface {
}

protocol DetailsPresenterInterface: PresenterInterface {
    func configure(with output: Details.ViewOutput) -> Details.ViewInput
}

protocol DetailsFormatterInterface: FormatterInterface {
    func format(for input: Details.FormatterInput) -> Details.FormatterOutput
}

protocol DetailsInteractorInterface: InteractorInterface {
}

enum Details {

    struct ViewOutput {
    }

    struct ViewInput {
        let models: FormatterOutput
    }

    struct FormatterInput {
    }

    struct FormatterOutput {
    }

}
```

When we introduced the <i>RxModule</i> we saw the *ViewInput* and *ViewOutput* structures. Now, they have friends :)

*FormatterInput* and *FormatterOutput* work in the same way as *ViewInput* and *ViewOutput* do. The main difference is that the *FormatterInput* is created in the Presenter and then the Presenter returns the *FormatterOutput* via the *ViewInput*. We set every bit of information needed for the Formatter to do its job. As a result, the Formatter returns the *FormatterOutput* where we set formatted information which we want to display. The *ViewInput* already has a <i>models</i> property which tells us that we need to return it.

The Formatter has a <i>format</i> method which, as previously explained, takes the *FormatterInput* as a parameter and then formats it into a *FormatterOutput* which holds the information in a way which our ViewController knows how to use. You can think of it just like the <i>configure</i> function from the Presenter. Takes an input, does whatever it's supposed to, in our case format the data, and returns an output.

### Presenter

```swift
final class DetailsPresenter {

    // MARK: - Private properties -

    private unowned let view: DetailsViewInterface
    private let formatter: DetailsFormatterInterface
    private let interactor: DetailsInteractorInterface
    private let wireframe: DetailsWireframeInterface

    // MARK: - Lifecycle -

    init(
        view: DetailsViewInterface,
        formatter: DetailsFormatterInterface,
        interactor: DetailsInteractorInterface,
        wireframe: DetailsWireframeInterface
    ) {
        self.view = view
        self.formatter = formatter
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension DetailsPresenter: DetailsPresenterInterface {

    func configure(with output: Details.ViewOutput) -> Details.ViewInput {

        let formatterInput = Details.FormatterInput()

        let formatterOutput = formatter.format(for: formatterInput)

        return Details.ViewInput(models: formatterOutput)
    }

}
```

Using the previously mentioned <i>format</i> method we convert the input into an output and send it via the *ViewInput* to the ViewController.

### Wireframe

The only change inside the wireframe is the initialization of the Formatter which now needs to be set in the Presenter's <i>init</i>.

```swift
    let formatter = DetailsFormatter()
```

### Formatter

```swift
final class DetailsFormatter {
}

// MARK: - Extensions -

extension DetailsFormatter: DetailsFormatterInterface {

    func format(for input: Details.FormatterInput) -> Details.FormatterOutput {
        return Details.FormatterOutput()
    }

}
```

The Formatter has the main <i>format</i> function which has to be called. If it's a more complex Formatter, you could have some properties which will help you separate code into even more classes. All the magic happens inside the <i>format</i> function. As we want to return the information in the correct format, we have to format it first, and that happens right there. However, you should follow the SRP and have functions that will create the needed models for you.


## 3. How does a Formatter look in action?

We talked about how it works and how it should work but it will be much more easier when you see the simple usage example. We created a RxModule inside the Demo app for the Details module with Formatter.

As we started with *Interfaces*, we'll do the same now:

### Interfaces

```swift
protocol DetailsWireframeInterface: WireframeInterface {
}

protocol DetailsViewInterface: ViewInterface {
}

protocol DetailsPresenterInterface: PresenterInterface {
    func configure(with output: Details.ViewOutput) -> Details.ViewInput
}

protocol DetailsFormatterInterface: FormatterInterface {
    func format(for input: Details.FormatterInput) -> Details.FormatterOutput
}

protocol DetailsInteractorInterface: InteractorInterface {
    func getShowDetails(for showId: String) -> Single<Show>
    func getAllReviews(for showId: String) -> Single<[Review]>
}

enum Details {

    struct ViewOutput {
    }

    struct ViewInput {
        let models: FormatterOutput
        let events: DetailsEvents
    }

    struct FormatterInput {
        let models: Driver<(Show, [Review])>
    }

    struct FormatterOutput {
        let sections: Driver<[TableSectionItem]>
    }

}

struct DetailsEvents {
    let title: Signal<String>
}
```

We only configured the *FormatterInput*, *ViewInput* and *FormatterOutput* structures. Since this is a very simple example, we had to add one property to the *ViewInput* <i>events</i> which will contain a title Driver. As we need items which will fill our tableView, we have a Driver with an array of TableSectionItems (you can find those on our [Nuts-and-bolts Github](https://github.com/infinum/iOS-Nuts-And-Bolts/tree/master/Sources/UI/DataSourceDelegate/Swift) and all other tableView supporting files). To get what we need, we have to provied the Formatter some information with a driver. We have to get the data about the show details and reviews for the show.

### Presenter

```swift
final class DetailsPresenter {

    // MARK: - Private properties -

    private unowned let view: DetailsViewInterface
    private let formatter: DetailsFormatterInterface
    private let interactor: DetailsInteractorInterface
    private let wireframe: DetailsWireframeInterface

    private let showId: String
    private let disposeBag: DisposeBag
    // MARK: - Lifecycle -

    init(
        view: DetailsViewInterface,
        formatter: DetailsFormatterInterface,
        interactor: DetailsInteractorInterface,
        wireframe: DetailsWireframeInterface,
        showId: String
    ) {
        self.view = view
        self.formatter = formatter
        self.interactor = interactor
        self.wireframe = wireframe

        self.disposeBag = DisposeBag()
        self.showId = showId
    }
}

// MARK: - Extensions -

extension DetailsPresenter: DetailsPresenterInterface {

    func configure(with output: Details.ViewOutput) -> Details.ViewInput {
        let titleRelay = PublishRelay<String>()
        let formatterInput = Details.FormatterInput(models: handleInitialLoad(titleRelay: titleRelay))

        let formatterOutput = formatter.format(for: formatterInput)

        return Details.ViewInput(
            models: formatterOutput,
            events: DetailsEvents(title: titleRelay.asSignal())
        )
    }

}

private extension DetailsPresenter {

    func handleInitialLoad(titleRelay: PublishRelay<String>) -> Driver<(Show, [Review])> {
        return Single.zip(
            interactor.getShowDetails(for: showId),
            interactor.getAllReviews(for: showId)
        )
            .do(onSuccess: { [unowned view] show, reviews in
                titleRelay.accept(show.title)
                view.hideProgressHUD()
            }, onError: { [unowned self] error in
                view.hideProgressHUD()
                showDetailsError(error)
            }, onSubscribe: { [unowned view] in
                view.showProgressHUD()
            })
            .asDriver(onErrorDriveWith: .empty())
    }

    func showDetailsError(_ error: Error) {
        wireframe.showAlert(with: "Error", message: error.localizedDescription)
    }
}
```

ShowId for a show that will be shown on details screen is injected in this module so we can create the fetching logic. Since this is a simple example, we only have the <i>configure</i> function with a <i>handleInitialLoad</i> function. Inside the configure function we configured our Formatter by calling the <i>format</i> function and passed the result in the *ViewInput*. It's the similar thing we did previously in the RxModule, we only have the Formatter component now.

As you can see, the Presenter doesn't have any mapping logic of our models. It only passes the models to the Formatter.

### ViewController, Wireframe and Interactor

There aren't any changes on how to use ViewController, Wireframe, and Interactor. We use the ViewController the same way as we did in the RxModule, by subscribing to events and reacting to them.

### Formatter

```swift
final class DetailsFormatter {
}

// MARK: - Extensions -

extension DetailsFormatter: DetailsFormatterInterface {

    func format(for input: Details.FormatterInput) -> Details.FormatterOutput {

        return Details.FormatterOutput(sections: handle(input.models))
    }

}

private extension DetailsFormatter {
    func handle(_ items: Driver<(Show, [Review])>) -> Driver<[TableSectionItem]> {
        return items
            .map { [unowned self] in
                createShowDetailsSectionItems(items: $0)
            }
    }

    func createShowDetailsSectionItems(items: (show: Show, reviews: [Review])) -> [ShowDetailsSection] {
        var showDetailsItems: [DetailsItem] = []
        showDetailsItems.append(contentsOf: createMandatoryItems(items.show))
        showDetailsItems.append(contentsOf: createReviewSection(with: items.show, items.reviews))
        return [ShowDetailsSection(items: showDetailsItems)]
    }

    func createMandatoryItems(_ show: Show) -> [DetailsItem] {
        var showDetailsItems: [DetailsItem] = []
        showDetailsItems.append(
            DetailsItem(
                model: ShowWithReviews(
                    show: show,
                    review: nil
                ),
                type: .image
            )
        )
        showDetailsItems.append(
            DetailsItem(
                model: ShowWithReviews(
                    show: show,
                    review: nil
                ),
                type: .description
            )
        )
        showDetailsItems.append(
            DetailsItem(
                model: ShowWithReviews(
                    show: nil,
                    review: nil
                ),
                type: .reviewsTitle
            )
        )
        return showDetailsItems
    }

    func createReviewSection(with show: Show, _ reviews: [Review]) -> [DetailsItem] {
        var showDetailsItems: [DetailsItem] = []
        guard reviews.isEmpty else {
            showDetailsItems.append(
                DetailsItem(
                    model: ShowWithReviews(
                        show: show,
                        review: nil
                    ),
                    type: .averageRating
                )
            )
            reviews.forEach { review in
                showDetailsItems.append(
                    DetailsItem(
                        model: ShowWithReviews(
                            show: nil,
                            review: review
                        ),
                        type: .review
                    )
                )
            }
            showDetailsItems.append(
                DetailsItem(
                    model: ShowWithReviews(
                        show: show,
                        review: nil
                    ),
                    type: .addReview
                )
            )
            return showDetailsItems
        }
        showDetailsItems.append(
            DetailsItem(
                model: ShowWithReviews(
                    show: show,
                    review: nil
                ),
                type: .noReviews
            )
        )
        return showDetailsItems
    }
}
```

Lastly, we get to our beloved Formatter. We only have the formatting/mapping logic inside the Formatter. Since it is a simple example, it doesn't have many lines of code but it still helps us with the maintainability and readability following the SRP. Inside the <i>format</i> function we use the same principle as with the Presenter. Formatter will take the networking models from the input and convert them into items consumed by the view. The Formatter can have much more formatting and item creation logic and that's why you want it in one place.

Hopefully, we managed to give some clarification on why, when and how we use the Formatter. We use it only when the Presenter is getting huge and a huge part of it is the item creation logic. 

Enjoy your newfound tool, use it wisely! :)

Cheers,

Infinum iOS team
