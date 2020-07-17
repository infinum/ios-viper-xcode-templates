# Viper 4.0 Migration Guide
Viper 4.0 is the latest and greatest edition of the Viper generator. The biggest change done is the change in Wireframe. Wireframes are now genric over it's `UIViewController` class. The reason for doing this is to allow users to constrain their `UIViewController`s to specific protocols if needed. 
#### Base Viper Interfaces
You will need to copy the new `BaseWireframe.swift` file to your project. Or at least you would need to make it generic, similar to one in this repo.
#### All your project Wireframe's
You will need to do one big search and replace in all your wireframes, to replace `BaseWireframe` with `BaseWireframe<UIViewController>`. Constraining them to `UIViewController` will give you the same functionalities as in Viper 3.0. But now you have the opportunity to go beyond that.

Happy Coding :)