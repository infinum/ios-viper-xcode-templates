//
//  JapxCodable.swift
//  Japx
//
//  Created by Vlaho Poluta on 25/01/2018.
//

import Foundation

/// Protocol that extends Decodable with required properties for JSON:API objects
public protocol JapxDecodable: Decodable {
    var type: String { get }
    var id: String { get }
}

/// Protocol that extends Encodable with required properties for JSON:API objects
public protocol JapxEncodable: Encodable {
    var type: String { get }
}

public typealias JapxCodable = JapxDecodable & JapxEncodable

/// Wrapper around JSONEncoder capable of encoding normal objects into JSON:API dictionaries
public final class JapxEncoder {
    
    // Underlying JSONEncoder, can be used to add date formats, ...
    public let jsonEncoder: JSONEncoder
    
    /// Options specifying how `Japx.Encoder` should encode JSON into JSON:API.
    public let options: Japx.Encoder.Options
    
    /// Initializes `self` with underlying `JSONEncoder` instance
    public init(jsonEncoder: JSONEncoder = JSONEncoder(), options: Japx.Encoder.Options = .default) {
        self.jsonEncoder = jsonEncoder
        self.options = options
    }
    
    /// Encodes the given top-level value and returns its JSON:API representation.
    ///
    /// - parameter value: The value to encode.
    /// - parameter additionalParams:  Additional [String: Any] to add with `data` to JSON:API object.
    /// - returns: A new `[String: Any]` value containing the encoded JSON:API data.
    /// - throws: An error if any value throws an error during encoding.
    public func encode<T>(_ value: T, additionalParams: Parameters? = nil) throws -> Parameters where T : Encodable {
        let data = try jsonEncoder.encode(value)
        return try Japx.Encoder.encode(data: data, additionalParams: additionalParams, options: options)
    }
}

/// Wrapper around JSONDecoder capable of decoding JSON:API objects into normal objects
public final class JapxDecoder {
    
    /// Underlying JSONDecoder, can be used to add date formats, ...
    public let jsonDecoder: JSONDecoder
    
    /// Options specifying how `Japx.Decoder` should decode JSON:API into JSON.
    public let options: Japx.Decoder.Options
    
    /// Initializes `self` with underlying `JSONDecoder` instance and `Japx.Decoder.Options`
    public init(jsonDecoder: JSONDecoder = JSONDecoder(), options: Japx.Decoder.Options = .default) {
        self.jsonDecoder = jsonDecoder
        self.options = options
    }
    
    /// Decodes a top-level value of the given type from the given JSON:API representation.
    ///
    /// - parameter type: The type of the value to decode.
    /// - parameter json: The JSON:API dictionary to decode from.
    /// - returns: A value of the requested type.
    /// - throws: An error if any value throws an error during decoding.
    public func decode<T>(_ type: T.Type, from json: Parameters, includeList: String? = nil) throws -> T where T : Decodable {
        let data = try Japx.Decoder.data(withJSONAPIObject: json, includeList: includeList, options: options)
        return try jsonDecoder.decode(type, from: data)
    }
    
    /// Decodes a top-level value of the given type from the given JSON:API representation.
    ///
    /// - parameter type: The type of the value to decode.
    /// - parameter data: The JSON:API formatted data to decode from.
    /// - returns: A value of the requested type.
    /// - throws: An error if any value throws an error during decoding.
    public func decode<T>(_ type: T.Type, from data: Data, includeList: String? = nil) throws -> T where T : Decodable {
        let data = try Japx.Decoder.data(with: data, includeList: includeList, options: options)
        return try jsonDecoder.decode(type, from: data)
    }
}
