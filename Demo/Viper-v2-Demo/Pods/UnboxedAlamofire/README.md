# UnboxedAlamofire

[![Build Status](https://travis-ci.org/serejahh/UnboxedAlamofire.svg?branch=master)](https://travis-ci.org/serejahh/UnboxedAlamofire)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/UnboxedAlamofire.svg)](https://img.shields.io/cocoapods/v/UnboxedAlamofire.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/UnboxedAlamofire.svg?style=flat)](http://cocoadocs.org/docsets/UnboxedAlamofire)

[Alamofire](https://github.com/Alamofire/Alamofire) + [Unbox](https://github.com/JohnSundell/Unbox): the easiest way to download and decode JSON into swift objects.

## Features

- [x] Unit tested
- [x] Fully documented
- [x] Mapping response to objects
- [x] Mapping response to array of objects
- [x] Keypaths
- [x] Nested keypaths
- [x] For Swift 2.x use v. `1.x` and [swift2](https://github.com/serejahh/UnboxedAlamofire/tree/swift2) branch
- [x] For Swift 3.x use v. `2.x`

## Usage

Objects you request have to conform [Unboxable](https://github.com/JohnSundell/Unbox#basic-example) protocol.

### Get an object

``` swift
Alamofire.request(url, method: .get).responseObject { (response: DataResponse<Candy>) in
    // handle response
    let candy = response.result.value
    
    // handle error
    if let error = response.result.error as? UnboxedAlamofireError {
        print("error: \(error.description)")
    }
}
```

### Get an array

``` swift
Alamofire.request(url, method: .get).responseArray { (response: DataResponse<[Candy]>) in
    // handle response
    let candies = response.result.value
    
    // handle error
    if let error = response.result.error as? UnboxedAlamofireError {
        print("error: \(error.description)")
    }
}
```

### KeyPath

Also you can specify a keypath in both requests:

``` swift
Alamofire.request(url, method: .get).responseObject(keyPath: "response") { (response: DataResponse<Candy>) in
    // handle response
    let candy = response.result.value
    
    // handle error
    if let error = response.result.error as? UnboxedAlamofireError {
        print("error: \(error.description)")
    }
}
```

## Installation

### [CocoaPods](https://cocoapods.org/)

```
pod 'UnboxedAlamofire', '~> 2.0'
```

### [Carthage](https://github.com/Carthage/Carthage)

```
github "serejahh/UnboxedAlamofire" ~> 2.0
```
