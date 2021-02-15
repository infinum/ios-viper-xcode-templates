# Viper 4.0 Migration Guide
Viper 4.0 is the latest and greatest edition of the Viper generator. The biggest new change related to the Wireframe. Wireframes are now generic over its `UIViewController` class. The reason for doing this is to allow users to constrain `UIViewController`s to specific protocols if needed. 
#### Base Viper Interfaces
You will need to copy the new `BaseWireframe.swift` file to your project. Or at least you would need to make it generic, similarly to the one in this repo.
#### All your project Wireframe's
You will need to do a single big search and replace all your wireframes. `BaseWireframe` needs to be replaced with `BaseWireframe<UIViewController>`. Constraining them to the `UIViewController` will give you the same functionalities as in Viper 3.0, but now you have the opportunity to go beyond that.

Happy Coding :)
