# VIPER Formatter

Disclaimer!!!
We will not be covering the basics of VIPER architecture. Everything can be found in the main README.md file.

## 1. What's a Formatter, why would I use it?

The first question you might ask yourself when glancing through our VIPER templates is what is a formatter and why would I even use it? Let me help you answer that one :)

A Formatter is a class which helps us, as the name says, format information into something that we can use to updated the UI. But why would we have another class to handle it for us when we can do it in the presenter? Isn't Presenter the one who would do that for us? The answer is very simple, we just want our Presenter with less lines of code. If you ever worked on a bigger project, you might have found yourself in a situation where one class has over one thousand lines of code... We don't like that, it's very hard to maintain and even if you try to make it as readable as possible, it's still too many lines of code. 

To achieve a much higher level of maintainability and readability, we remove the Presenter's formatting task and add the, already mentioned class, Formatter inside the Presenter. We only use the Formatter when there is a need for it, eg. we have a Presenter with 700 lines of code from which 400 are formatting functions. It's much easier to add a new class and have the formatting functionality in that class. After we have added the Formatter, we're left with a Presenter which doesn't know anything about how the information which he needs is created, only that he gets it and the Formatter's responsibility is to give it the needed information. We separate the responsibilities which is always a great result to have.

Another usage example would be when you reuse a screen and it needs different data to render. If the whole logic about formatting the information was inside the Presenter it would take too many lines of code. That's where the Formatter would jump in to the rescue. Even if you had two different formatters in a complex screen, it would help you out where you would just need to pay attention to which formatter you need and when.


## 2. How do I create one?

Since you're at the VIPER templates Github, you might have guessed the answer to that one, we can generate it for you! :)

When we're trying to generate a module with Interactor + Formatter, we get the generated Formatter with other classes from that module. In this guide we'll generate the Interactor + Formatter from RxModule since we're trying to use Rx as much as possible.

If you have any doubts about your understanding of the RxModule and which classes it generates for us, please visit the <i>RxModule VIPER guide</i>. We'll go through the files which differ from the base RxModule with Interactor. Those are: *Interfaces*, *Presenter*, *Wireframe*, and the star of the show *Formatter*. In this case, we'll generate a module named <i>RxPokemonDetails</i>.

As you can see from the changed files, there's no *ViewController* and *Interactor*, they stay the same.

### Interfaces

```swift
protocol RxPokemonDetailsWireframeInterface: WireframeInterface {
}

protocol RxPokemonDetailsViewInterface: ViewInterface {
}

protocol RxPokemonDetailsPresenterInterface: PresenterInterface {
    func configure(with output: RxPokemonDetails.ViewOutput) -> RxPokemonDetails.ViewInput
}

protocol RxPokemonDetailsFormatterInterface: FormatterInterface {
    func format(for input: RxPokemonDetails.FormatterInput) -> RxPokemonDetails.FormatterOutput
}

protocol RxPokemonDetailsInteractorInterface: InteractorInterface {
}

enum RxPokemonDetails {

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

FormatterInput and FormatterOutput work in the same way as *ViewInput* and *ViewOutput* do. The main difference is that the *FormatterInput* is created in the Presenter and then the Presenter returns the *FormatterOutput* via the *ViewInput*. We set every bit of information needed for the Formatter to do its job. As a result, the Formatter returns the *FormatterOutput* where we set formatted infromation which we want to display. The *ViewInput* already has a <i>models</i> property which tells us that we need to return it.

The Formatter has a function <i>format</i> which, as previously explained, takes the *FormatterInput* as a parameter and then formats it into a *FormatterOutput* which holds the information in a way which our ViewController knows how to use. You can think of it just like the <i>configure</i> function from the Presenter. Takes an input, does whatever it's supposed to, in our case format the data, and returns an output.

### Presenter

```swift
final class RxPokemonDetailsPresenter {

    // MARK: - Private properties -

    private unowned let view: RxPokemonDetailsViewInterface
    private let formatter: RxPokemonDetailsFormatterInterface
    private let interactor: RxPokemonDetailsInteractorInterface
    private let wireframe: RxPokemonDetailsWireframeInterface

    // MARK: - Lifecycle -

    init(
        view: RxPokemonDetailsViewInterface,
        formatter: RxPokemonDetailsFormatterInterface,
        interactor: RxPokemonDetailsInteractorInterface,
        wireframe: RxPokemonDetailsWireframeInterface
    ) {
        self.view = view
        self.formatter = formatter
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension RxPokemonDetailsPresenter: RxPokemonDetailsPresenterInterface {

    func configure(with output: RxPokemonDetails.ViewOutput) -> RxPokemonDetails.ViewInput {

        let formatterInput = RxPokemonDetails.FormatterInput()

        let formatterOutput = formatter.format(for: formatterInput)

        return RxPokemonDetails.ViewInput(models: formatterOutput)
    }

}
```

As we previously mentioned, the Presenter communicates with the Formatter since Formatter contains business logic. Also, our Presenter will contain the Formatter, as you might have already figured out from the *FormatterInput* and *FormatterOutput* structures, it's a two-way communication. The presenter creates an instance of the *FormatterInput* which contains models/information which need to be formatted in a way that the ViewController knows how to use it. Using the <i>format</i> function we convert the input into an output and send it via the *ViewInput* to the ViewController.

### Wireframe

The only change inside the wireframe is the initialization of the Formatter which now needs to be set in the Presenter's <i>init</i>.

```swift
        let formatter = RxPokemonDetailsFormatter()
```

### Formatter

```swift
final class RxPokemonDetailsFormatter {
}

// MARK: - Extensions -

extension RxPokemonDetailsFormatter: RxPokemonDetailsFormatterInterface {

    func format(for input: RxPokemonDetails.FormatterInput) -> RxPokemonDetails.FormatterOutput {
        return RxPokemonDetails.FormatterOutput()
    }

}
```

The Formatter has the main <i>format</i> function which has to be called. If it's a more complex Formatter, you could have some properties which will help you separate code into even more classes. All the magic happens inside the <i>format</i> function. As we want to return the information in the correct format, we have to format it first, and that happens right there. However, you should follow the SRP and have functions which will create the needed models for you.


## 3. How does a Formatter look in action?

We talked about how it works and how it should work but it's much easier if we show you a simple usage example. We created an RxModule inside the Demo app for the Details module with Formatter. It's just a simple usage how it's supposed to work.

As we started with *Interfaces*, we'll do the same now:

### Interfaces

```swift
protocol RxPokemonDetailsWireframeInterface: WireframeInterface {
}

protocol RxPokemonDetailsViewInterface: ViewInterface {
}

protocol RxPokemonDetailsPresenterInterface: PresenterInterface {
    func configure(with output: RxPokemonDetails.ViewOutput) -> RxPokemonDetails.ViewInput
}

protocol RxPokemonDetailsFormatterInterface: FormatterInterface {
    func format(for input: RxPokemonDetails.FormatterInput) -> RxPokemonDetails.FormatterOutput
}

protocol RxPokemonDetailsInteractorInterface: InteractorInterface {
}

enum RxPokemonDetails {

    struct ViewOutput {
    }

    struct ViewInput {
        let models: FormatterOutput
        let events: RxPokemonDetailsEvent
    }

    struct FormatterInput {
        let models: Driver<Pokemon>
    }

    struct FormatterOutput {
        let sections: Driver<[TableSectionItem]>
    }

}

struct RxPokemonDetailsEvent {
    let title: Driver<String>
    let imageURL: Signal<URL>
}
```

We only configured the *FormatterInput*, *ViewInput* and *FormatterOutput* structures. Since this is a very simple example, we had to add one property to the *ViewInput* <i>events</i> which will have a title Driver and the header image URL. As we need items which will fill our tableView, we have a Driver with an array of TableSectionItems (you can find those on our Nuts-and-bolts Github and all other tableView supporting files). The only thing we'll send to the Formatter is the Pokemon model and we'll convert the TableSectionItems from that.

### Presenter

```swift
final class RxPokemonDetailsPresenter {

    // MARK: - Private properties -

    private unowned let view: RxPokemonDetailsViewInterface
    private let formatter: RxPokemonDetailsFormatterInterface
    private let interactor: RxPokemonDetailsInteractorInterface
    private let wireframe: RxPokemonDetailsWireframeInterface

    private let pokemon: Pokemon

    // MARK: - Lifecycle -

    init(
        view: RxPokemonDetailsViewInterface,
        formatter: RxPokemonDetailsFormatterInterface,
        interactor: RxPokemonDetailsInteractorInterface,
        wireframe: RxPokemonDetailsWireframeInterface,
        pokemon: Pokemon
    ) {
        self.view = view
        self.formatter = formatter
        self.interactor = interactor
        self.wireframe = wireframe

        self.pokemon = pokemon
    }
}

// MARK: - Extensions -

extension RxPokemonDetailsPresenter: RxPokemonDetailsPresenterInterface {

    func configure(with output: RxPokemonDetails.ViewOutput) -> RxPokemonDetails.ViewInput {
        let pokemon = Driver.just(pokemon)
        let formatterInput = RxPokemonDetails.FormatterInput(models: pokemon)

        let formatterOutput = formatter.format(for: formatterInput)

        let title = Driver.just(self.pokemon.title).compactMap { $0 }
        let imageURL = Signal.just(self.pokemon.imageURL).compactMap { $0 }
        return RxPokemonDetails.ViewInput(models: formatterOutput, events: RxPokemonDetailsEvent(title: title, imageURL: imageURL))
    }

}
```

We added a property Pokemon since we open the screen by clicking on a Pokemon and we don't make any API calls. Since this is a simple example, we only have the <i>configure</i> function. Inside the configure function we configured our Formatter by calling the <i>format</i> function and our *ViewInput*. It's the same as we did it previously in the RxModule, we only have the Formatter component now.

As you can see, the Presenter doesn't have any mapping logic of our models it only passes the models to the Formatter.

### ViewController, Wireframe and Interactor

There aren't any changes on how to use ViewController, Wireframe and Interactor. We use the ViewController the same way as we did in the RxModule, by subscribing to events and reacting to them.

### Formatter

```swift
final class RxPokemonDetailsFormatter {
}

// MARK: - Extensions -

extension RxPokemonDetailsFormatter: RxPokemonDetailsFormatterInterface {

    func format(for input: RxPokemonDetails.FormatterInput) -> RxPokemonDetails.FormatterOutput {
        return RxPokemonDetails.FormatterOutput(sections: createTableViewSections(from: input.models))
    }

}

private extension RxPokemonDetailsFormatter {

    func createTableViewSections(from pokemon: Driver<Pokemon>) -> Driver<[TableSectionItem]> {
        pokemon
            .map { [unowned self] in  createSections(with: $0)}
    }

    func createSections(with pokemon: Pokemon) -> [TableSectionItem] {
        var items: [TableSectionItem] = []
        items.append(createDescriptionSection(pokemon))
        return items
    }

    func createDescriptionSection(_ pokemon: Pokemon) -> TableSectionItem {
        return RxPokemonDetailsSection(items: [RxPokemonDetailsItem(model: PokemonDetailsItem.description(pokemon))])
    }

}
```

Lastly, we get to our beloved Formatter. We only have the formatting/mapping logic inside the Formatter. Since it is a simple example, it doesn't have many lines of code but it's still helps us with the maintainability and readability following the SRP. Inside the <i>format</i> function we use the same principle as with the Presenter. Take the items from the input and convert them into needed models. The Formatter can have much more formatting and item creating logic and that's why you want it in one place.

Hopefully, we managed to give some clarification on why, when and how we use the Formatter. We use it only when the Presenter is getting huge and a huge part of it is the item creation logic. 

Enjoy your newfound tool, use it wisely! :)
Infinum iOS team
