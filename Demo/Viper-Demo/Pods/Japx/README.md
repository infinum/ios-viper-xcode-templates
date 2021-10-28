# Japx - JSON:API Decoder/Encoder

[![Build Status](https://app.bitrise.io/app/76e0e1ec75e38509/status.svg?token=8DTyJT_7TdJQIKIJuURq2w&branch=master)](https://app.bitrise.io/app/76e0e1ec75e38509)
[![Version](https://img.shields.io/cocoapods/v/Japx.svg?style=flat)](http://cocoapods.org/pods/Japx)
[![License](https://img.shields.io/cocoapods/l/Japx.svg?style=flat)](http://cocoapods.org/pods/Japx)
[![Platform](https://img.shields.io/cocoapods/p/Japx.svg?style=flat)](http://cocoapods.org/pods/Japx)

<p align="center">
    <img src="img/japx-logo.png" width="300" max-width="50%" alt="Japx"/>
</p>

Lightweight [JSON:API][1] parser that flattens complex [JSON:API][1] structure and turns it into simple JSON and vice versa.
It works by transferring `Dictionary` to `Dictionary`, so you can use [Codable][2], [Unbox][3], [Wrap][4], [ObjectMapper][5] or any other object mapping tool that you prefer.

- [Japx - JSON:API Decoder/Encoder](#japx---jsonapi-decoderencoder)
  - [Basic example](#basic-example)
  - [Advanced examples](#advanced-examples)
    - [Parsing relationships](#parsing-relationships)
    - [Parsing additional information](#parsing-additional-information)
    - [Parsing with include list](#parsing-with-include-list)
  - [Usage](#usage)
    - [Codable](#codable)
    - [Codable and Alamofire](#codable-and-alamofire)
    - [Codable, Alamofire and RxSwift](#codable-alamofire-and-rxswift)
  - [Installation](#installation)
    - [Cocoapods](#cocoapods)
    - [Swift Package Manager](#swift-package-manager)
    - [Carthage](#carthage)
  - [Example project](#example-project)
  - [Authors](#authors)
  - [License](#license)

## Basic example

For given example of JSON object:

```json
{
    "data": {
        "id": "1",
        "type": "users",
        "attributes": {
            "email": "john@infinum.co",
            "username": "john"
        }
    }
}
```

to parse it to simple JSON use:

```swift
let jsonApiObject: [String: Any] = ...
let simpleObject: [String: Any]

do {
    simpleObject = try JapxKit.Decoder.jsonObject(withJSONAPIObject: jsonApiObject)
} catch {
    print(error)
}
```

and parser will convert it to object where all properties inside `attributes` object will be flattened to the root of `data` object:

```json
{
    "data": {
        "email": "john@infinum.co",
        "id": "1",
        "username": "john",
        "type": "users"
    }
}
```

## Advanced examples

### Parsing relationships

Simple `Article` object which has its `Author`:

```json
{
    "data": [
        {
            "type": "articles",
            "id": "1",
            "attributes": {
                "title": "JSON API paints my bikeshed!",
                "body": "The shortest article. Ever.",
                "created": "2015-05-22T14:56:29.000Z",
                "updated": "2015-05-22T14:56:28.000Z"
            },
            "relationships": {
                "author": {
                    "data": {
                        "id": "42",
                        "type": "people"
                    }
                }
            }
        }
    ],
    "included": [
        {
            "type": "people",
            "id": "42",
            "attributes": {
                "name": "John",
                "age": 80,
                "gender": "male"
            }
        }
    ]
}
```

will be flattened to:

```json
{
    "data": [
        {
            "updated": "2015-05-22T14:56:28.000Z",
            "author": {
                "age": 80,
                "id": "42",
                "gender": "male",
                "type": "people",
                "name": "John"
            },
            "id": "1",
            "title": "JSON API paints my bikeshed!",
            "created": "2015-05-22T14:56:29.000Z",
            "type": "articles",
            "body": "The shortest article. Ever."
        }
    ]
}
```

### Parsing additional information

All nested object which do not have keys defined in [JSON:API Specification][6] will be left inside root object intact (same goes for `links` and `meta` objects):

```json
{
    "data": [
        {
            "type": "articles",
            "id": "3",
            "attributes": {
                "title": "JSON API paints my bikeshed!",
                "body": "The shortest article. Ever.",
                "created": "2015-05-22T14:56:29.000Z",
                "updated": "2015-05-22T14:56:28.000Z"
            }
        }
    ],
    "meta": {
        "total-pages": 13
    },
    "links": {
        "self": "http://example.com/articles?page[number]=3&page[size]=1",
        "first": "http://example.com/articles?page[number]=1&page[size]=1",
        "prev": "http://example.com/articles?page[number]=2&page[size]=1",
        "next": "http://example.com/articles?page[number]=4&page[size]=1",
        "last": "http://example.com/articles?page[number]=13&page[size]=1"
    },
    "additional": {
        "info": "My custom info"
    }
}
```

Parsed JSON:

```json
{
    "data": [
        {
            "updated": "2015-05-22T14:56:28.000Z",
            "id": "3",
            "title": "JSON API paints my bikeshed!",
            "created": "2015-05-22T14:56:29.000Z",
            "type": "articles",
            "body": "The shortest article. Ever."
        }
    ],
    "meta": {
        "total-pages": 13
    },
    "links": {
        "prev": "http://example.com/articles?page[number]=2&page[size]=1",
        "first": "http://example.com/articles?page[number]=1&page[size]=1",
        "next": "http://example.com/articles?page[number]=4&page[size]=1",
        "self": "http://example.com/articles?page[number]=3&page[size]=1",
        "last": "http://example.com/articles?page[number]=13&page[size]=1"
    },
    "additional": {
        "info": "My custom info"
    }
}
```

### Parsing with include list

For defining which nested object you want to parse, you can use `includeList` parameter. For example:

```json
{
    "data": {
        "type": "articles",
        "id": "1",
        "attributes": {
            "title": "JSON API paints my bikeshed!",
            "body": "The shortest article. Ever.",
            "created": "2015-05-22T14:56:29.000Z",
            "updated": "2015-05-22T14:56:28.000Z"
        },
        "relationships": {
            "author": {
                "data": {
                    "id": "42",
                    "type": "people"
                }
            }
        }
    },
    "included": [
        {
            "type": "people",
            "id": "42",
            "attributes": {
                "name": "John",
                "age": 80,
                "gender": "male"
            },
            "relationships": {
                "article": {
                    "data": {
                        "id": "1",
                        "type": "articles"
                    }
                }
            }
        }
    ]
}
```

`Article` and `Author` can be matched using include reference, as defined in [JSON:API Specification][6]:

```swift
let includeList: String = "author.article.author"
let jsonApiObject: [String: Any] = ...
let recursiveObject: [String: Any] = try JapxKit.Decoder.jsonObject(with: jsonApiObject, includeList: includeList)
```

Parsed JSON:

```json
{
    "data": {
        "type": "articles",
        "id": "1",
        "title": "JSON API paints my bikeshed!",
        "body": "The shortest article. Ever.",
        "created": "2015-05-22T14:56:29.000Z",
        "updated": "2015-05-22T14:56:28.000Z",
        "author": {
            "type": "people",
            "id": "42",
            "name": "John",
            "age": 80,
            "gender": "male",
            "article": {
                "type": "articles",
                "id": "1",
                "title": "JSON API paints my bikeshed!",
                "body": "The shortest article. Ever.",
                "created": "2015-05-22T14:56:29.000Z",
                "updated": "2015-05-22T14:56:28.000Z",
                "author": {
                    "type": "people",
                    "id": "42",
                    "name": "John",
                    "age": 80,
                    "gender": "male"
                }
            }
        }
    }
}
```

## Usage

### Codable

Japx comes with wrapper for _Swift_ [Codable][7].

Since JSON:API object can have multiple additional fields like meta, links or pagination info, its real model needs to be wrapped inside `data` object. For easier parsing, also depending on your API specification, you should create wrapping native object which will contain your generic JSON model:

```swift
struct JapxResponse<T: Codable>: Codable {
    let data: T
    // ... additional info like: meta, links, pagination...
}

struct User: JapxCodable {
    let id: String
    let type: String
    let email: String
    let username: String
}

let userResponse: JapxResponse<User> = try JapxDecoder().decode(JapxResponse<User>.self, from: data)
let user: User = userResponse.data
```

where `JapxDecodable` and `JapxEncodable` are defined in `JapxCodable` file as:

```swift
/// Protocol that extends Decodable with required properties for JSON:API objects
protocol JapxDecodable: Decodable {
    var type: String { get }
    var id: String { get }
}

/// Protocol that extends Encodable with required properties for JSON:API objects
protocol JapxEncodable: Encodable {
    var type: String { get }
}
```

### Codable and Alamofire

Japx also comes with wrapper for [Alamofire][10] and [Codable][7] which can be installed as described in [installation](#installation) chapter.

Use `responseCodableJSONAPI` method on `DataRequest` which will pass serialized response in callback. Also, there is `keyPath` argument to extract only nested `data` object. So, if you don't need any additional info from API side except plain data, than you can create simple objects, without using wrapping objects/structs.

```swift
struct User: JapxCodable {
    let id: String
    let type: String
    let email: String
    let username: String
}

Alamofire
    .request(".../api/v1/users/login", method: .post, parameters: [...])
    .validate()
    .responseCodableJSONAPI(keyPath: "data", completionHandler: { (response: DataResponse<User>) in
        switch response.result {
        case .success(let user):
            print(user)
        case .failure(let error):
            print(error)
        }
    })
```

### Codable, Alamofire and RxSwift

Japx also comes with wrapper for [Alamofire][10], [Codable][7] and [RxSwift][11] which can be installed as described in [installation](#installation) chapter.

Use `responseCodableJSONAPI` method from `.rx` extension on `DataRequest` which will return `Single` with serialized response.

```swift
let loginModel: LoginModel = ...
let executeLogin: ([String: Any]) throws -> Single<User> = {
    return Alamofire
        .request(".../api/v1/users/login", method: .post, parameters: $0)
        .validate()
        .rx.responseCodableJSONAPI(keyPath: "data")
}

return Single.just(loginModel)
        .map { try JapxEncoder().encode($0) }
        .flatMap(executeLogin)
```

## Installation

### Cocoapods

Japx is available through [CocoaPods][8]. To install it, simply add the following line to your Podfile:

```ruby
pod 'Japx'
```

We've also added some more functionalites like Alamofre or Moya for networking, Rx for reactive programming approach, Objective-C support:

```ruby
# Alamofire
pod 'Japx/Alamofire'

# Alamofire and RxSwift
pod 'Japx/RxAlamofire'

# Moya
pod 'Japx/Moya'

# Moya and RxSwift
pod 'Japx/RxMoya'

# Objective-C
pod 'Japx/ObjC'
```

Unlike with other dependency managers below, you should always use:

```swift
import Japx
```

regardless of which custom integration you've picked.

**NOTE: Version 4.0.0 of Japx points to Moya `development` branch due to Rx support issues. If you need stable Moya support, please use version 3.0.0. Otherwise point your Podfile to development Moya:**

```ruby
platform :ios, '10.0'
use_frameworks!

target 'MyApp' do

  pod 'Moya', :git => "https://github.com/Moya/Moya.git", :branch => "development"
  pod 'Japx/RxMoya'
end
```

### Swift Package Manager

Add the dependency to your `Package.swift` and use in your target

```swift
dependencies: [
    .package(url: "https://github.com/infinum/Japx.git", .upToNextMajor(from: "4.0.0"))
]
```

Sample `Package.swift`

```swift
let package = Package(
    name: "YourDependency",
    products: [
        .library(name: "YourDependency", targets: ["YourDependency"])
    ],
    dependencies: [
        .package(url: "https://github.com/infinum/Japx.git", .upToNextMajor(from: "4.0.0")),
    ],
    targets: [
        .target(
            name: "YourDependency",
            dependencies: [.product(name: "Japx", package: "Japx")]
        )
    ]
)
```

We've also added some more functionalites like Alamofre or Moya for networking, Rx for reactive programming approach:

``` swift
// Alamofire
.product(name: "JapxAlamofire", package: "Japx")

// Alamofire and RxSwift
.product(name: "JapxRxAlamofire", package: "Japx")

// Moya
.product(name: "JapxMoya", package: "Japx")

// Moya and RxSwift
.product(name: "JapxRxMoya", package: "Japx")
```

Depending on which product you've picked, you'll have to import different modules:

```swift
// Pure Japx
import Japx

// Alamofire
import JapxAlamofire

// Alamofire and RxSwift
import JapxRxAlamofire

// Moya
import JapxMoya

// Moya and RxSwift
import JapxRxMoya
```

### Carthage

Run `carthage update --use-xcframeworks` and import desired integration. Pure `Japx` doesn't have any dependencies.

Imports work same as for Swift Package Manager, depending on which integration you've picked.

**NOTE: Moya integration is currently not supported via Carthage since latest Moya build won't build with Carthage. More info [here](https://github.com/Moya/Moya/issues/2165).**

## Example project

Example project of Japx networking using Codable and Alamofire can be found in [Nuts And Bolts repository][12] with commonly used code. [Example][13] will cover how to handle basic CRUD (Create, Read, Update, Delete) operations with Japx and JSON:API format. To run the example, clone the [repository][12], open the `Catalog.xcworkspace`, run Catalog app and navigate to the Japx Networking section.

In this repository there is also a simple example project, to run it open `Japx.xcodeproj` and inspect `Example` directory and Japx_Example scheme. 

Basic integrations with Cocoapods (run `pod install`), Swift Package Manager and Carthage can be found inside `Examples` directory.

## Authors

* Vlaho Poluta, vlaho.poluta@infinum.hr
* Filip Gulan, filip.gulan@infinum.hr

Maintained by [Infinum][9]

<p align="center">
    <img src="img/infinum-logo.png" width="300" max-width="70%" alt="Infinum"/>
</p>

## License

Japx is available under the MIT license. See the LICENSE file for more info.

[1]:    http://jsonapi.org/
[2]:    https://developer.apple.com/documentation/swift/codable
[3]:    https://github.com/JohnSundell/Unbox
[4]:    https://github.com/JohnSundell/Wrap
[5]:    https://github.com/Hearst-DD/ObjectMapper
[6]:    http://jsonapi.org/format
[7]:    https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types
[8]:    http://cocoapods.org
[9]:    https://infinum.co
[10]:   https://github.com/Alamofire/Alamofire
[11]:   https://github.com/ReactiveX/RxSwift
[12]:   https://github.com/infinum/iOS-Nuts-And-Bolts
[13]:   https://github.com/infinum/iOS-Nuts-And-Bolts/tree/master/Catalog/Examples/Networking/Japx
