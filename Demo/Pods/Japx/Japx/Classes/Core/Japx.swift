//
//  Japx.swift
//  Japx
//
//  Created by Vlaho Poluta on 15/01/2018.
//  Copyright © 2018 Vlaho Poluta. All rights reserved.
//

import Foundation

/// `Parameters` is a simplification for writing [String: Any]
public typealias Parameters = [String: Any]

/// `JapxError` is the error type returned by Japx.
public enum JapxError: Error {
    /// - cantProcess(data:): Returned when `data` is not [String: Any] or [[String: Any]]
    case cantProcess(data: Any)
    /// - notDictionary(data:,value:): Returned when `value` in `data` is not [String: Any], when it should be [String: Any]
    case notDictionary(data: Any, value: Any?)
    /// - notFoundTypeOrId(data:): Returned when `type` or `id` are not found in `data`, when they were both supposed to be present.
    case notFoundTypeOrId(data: Any)
    /// - relationshipNotFound(data:): Returned when `relationship` isn't [String: Any], it should be [String: Any]
    case relationshipNotFound(data: Any)
    /// - unableToConvertNSDictionaryToParams(data:): Returned when conversion from NSDictionary to [String: Any] is unsuccessful.
    case unableToConvertNSDictionaryToParams(data: Any)
    /// - unableToConvertDataToJson(data:): Returned when conversion from Data to [String: Any] is unsuccessful.
    case unableToConvertDataToJson(data: Any)
}

private struct Consts {
    
    struct APIKeys {
        static let data = "data"
        static let id = "id"
        static let type = "type"
        static let included = "included"
        static let relationships = "relationships"
        static let attributes = "attributes"
        static let meta = "meta"
    }
    
    struct General {
        static let dictCapacity = 20
    }
}

private struct TypeIdPair {
    let type: String
    let id: String
}

/// A class for converting (parsing) JSON:API object to simple JSON object and vice versa.
public struct Japx {
    
    /// Defines a list of methods for converting JSON:API object structure to simple JSON by flattening attributes and relationships.
    public enum Decoder {}
    
    /// Defines a list of methods for converting simple JSON objects to JSON:API object.
    public enum Encoder {}
}

public extension Japx.Decoder {
    
    /// `Japx.Decoder.Options` is a set of options affecting the decoding of JSON:API into JSON you request from `Japx.Decoder`.
    struct Options {
        
        /// Defines if a relationship that doesn't have related object stored in `included`
        /// shoud be parsed as a dictionary of only `type` and `id`.
        /// If `false` it will be parsed as `nil`.
        ///
        /// Defaults to false.
        ///
        /// - Tag: parseNotIncludedRelationships
        public var parseNotIncludedRelationships: Bool = false
        
        /// Creates an instance with the specified properties.
        ///
        /// - parameter parseNotIncludedRelationships: Read more [here](parseNotIncludedRelationships)
        ///
        /// - returns: The new `Japx.Decoder.Options` instance.
        public init(parseNotIncludedRelationships: Bool = false) {
            self.parseNotIncludedRelationships = parseNotIncludedRelationships
        }
    }
}

public extension Japx.Decoder.Options {
    
    /// Default JSON:API to JSON decoding options for `Japx.Decoder`
    static var `default`: Japx.Decoder.Options { .init() }
}

public extension Japx.Encoder {
    
    /// `Japx.Encoder.Options` is a set of options affecting the encoding of JSON into JSON:API you requested from `Japx.Encoder`.
    struct Options {
        
        /// Common namespace is a set of all attribute names, relationship names, keyword `type` and keyword `id`.
        /// If enabled it will include keyword `meta` into that common namespace, making it a part of JSON:API.
        /// i.e. meta will be encoded on the same level as `attributes` and `relationships`.
        /// You should note that by including meta in the common namespace you are prohibited from using keyword `meta` as a name
        /// of an attribute or relationship, since it will lead to unwanted results - encoding in the wrong place.
        ///
        ///
        /// Defaults to false.
        ///
        /// - Tag: includeMetaToCommonNamespce
        public var includeMetaToCommonNamespce: Bool = false
        
        /// Creates an instance with the specified properties.
        ///
        /// - parameter includeMetaToCommonNamespce: Read more [here](includeMetaToCommonNamespce)
        ///
        /// - returns: The new `Japx.Decoder.Options` instance.
        public init(includeMetaToCommonNamespce: Bool = false) {
            self.includeMetaToCommonNamespce = includeMetaToCommonNamespce
        }
    }
}

public extension Japx.Encoder.Options {
    
    /// Default JSON to JSON:API decoding options for `Japx.Encoder`
    static var `default`: Japx.Encoder.Options { .init() }
}

// MARK: - Public interface -

// MARK: - Decoding

public extension Japx.Decoder {
    
    /// Converts JSON:API object to simple flat JSON object
    ///
    /// - parameter object:            JSON:API object.
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    /// - parameter options:           Options specifying how `Japx.Decoder` should decode JSON:API into JSON.
    ///
    /// - returns: JSON object.
    static func jsonObject(withJSONAPIObject object: Parameters, includeList: String? = nil, options: Japx.Decoder.Options = .default) throws -> Parameters {
        // First check if JSON API object has `include` list since
        // parsing objects with include list is done using native
        // Swift dictionary, while objects without it use `NSDictionary`
        let decoded: Any
        if let includeList = includeList {
            decoded = try decode(jsonApiInput: object, include: includeList, options: options)
        } else {
            decoded = try decode(jsonApiInput: object as NSDictionary, options: options)
        }
        if let decodedProperties = decoded as? Parameters {
            return decodedProperties
        }
        throw JapxError.unableToConvertNSDictionaryToParams(data: decoded)
    }
    
    /// Converts JSON:API object to simple flat JSON object
    ///
    /// - parameter object:            JSON:API object.
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    /// - parameter options:           Options specifying how `Japx.Decoder` should decode JSON:API into JSON.
    ///
    /// - returns: JSON object as Data.
    static func data(withJSONAPIObject object: Parameters, includeList: String? = nil, options: Japx.Decoder.Options = .default) throws -> Data {
        let decoded = try jsonObject(withJSONAPIObject: object, includeList: includeList, options: options)
        return try JSONSerialization.data(withJSONObject: decoded)
    }
    
    /// Converts JSON:API object to simple flat JSON object
    ///
    /// - parameter data:              JSON:API object as Data.
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    /// - parameter options:           Options specifying how `Japx.Decoder` should decode JSON:API into JSON.
    ///
    /// - returns: JSON object.
    static func jsonObject(with data: Data, includeList: String? = nil, options: Japx.Decoder.Options = .default) throws -> Parameters {
        let jsonApiObject = try JSONSerialization.jsonObject(with: data)
        
        // With include list
        if let includeList = includeList {
            guard let json = jsonApiObject as? Parameters else {
                throw JapxError.unableToConvertDataToJson(data: data)
            }
            return try decode(jsonApiInput: json, include: includeList, options: options)
        }
        
        // Without include list
        guard let json = jsonApiObject as? NSDictionary else {
            throw JapxError.unableToConvertDataToJson(data: data)
        }
        let decoded = try decode(jsonApiInput: json as NSDictionary, options: options)
        
        if let decodedProperties = decoded as? Parameters {
            return decodedProperties
        }
        throw JapxError.unableToConvertNSDictionaryToParams(data: decoded)
    }
    
    /// Converts JSON:API object to simple flat JSON object
    ///
    /// - parameter data:              JSON:API object as Data.
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    /// - parameter options:           Options specifying how `Japx.Decoder` should decode JSON:API into JSON.
    ///
    /// - returns: JSON object as Data.
    static func data(with data: Data, includeList: String? = nil, options: Japx.Decoder.Options = .default) throws -> Data {
        let decoded = try jsonObject(with: data, includeList: includeList, options: options)
        return try JSONSerialization.data(withJSONObject: decoded)
    }
}

// MARK: - Encoding

public extension Japx.Encoder {
    
    /// Converts simple flat JSON object to JSON:API object.
    ///
    /// - parameter data:              JSON object as Data.
    /// - parameter additionalParams:  Additional [String: Any] to add with `data` to JSON:API object.
    /// - parameter options:           Options specifying how `Japx.Encoder` should encode JSON into JSON:API.
    ///
    /// - returns: JSON:API object.
    static func encode(data: Data, additionalParams: Parameters? = nil, options: Japx.Encoder.Options = .default) throws -> Parameters {
        let json = try JSONSerialization.jsonObject(with: data)
        if let jsonObject = json as? Parameters {
            return try encode(json: jsonObject, additionalParams: additionalParams, options: options)
        }
        if let jsonArray = json as? [Parameters] {
            return try encode(json: jsonArray, additionalParams: additionalParams, options: options)
        }
        throw JapxError.unableToConvertDataToJson(data: json)
    }
    
    /// Converts simple flat JSON object to JSON:API object.
    ///
    /// - parameter json:              JSON object.
    /// - parameter additionalParams:  Additional [String: Any] to add with `data` to JSON:API object.
    /// - parameter options:           Options specifying how `Japx.Encoder` should encode JSON into JSON:API.
    ///
    /// - returns: JSON:API object.
    static func encode(json: Parameters, additionalParams: Parameters? = nil, options: Japx.Encoder.Options = .default) throws -> Parameters {
        var params = additionalParams ?? [:]
        params[Consts.APIKeys.data] = try encodeAttributesAndRelationships(on: json, options: options)
        return params
    }
    
    /// Converts simple flat JSON object to JSON:API object.
    ///
    /// - parameter json:              JSON objects represented as Array.
    /// - parameter additionalParams:  Additional [String: Any] to add with `data` to JSON:API object.
    /// - parameter options:           Options specifying how `Japx.Encoder` should encode JSON into JSON:API.
    ///
    /// - returns: JSON:API object.
    static func encode(json: [Parameters], additionalParams: Parameters? = nil, options: Japx.Encoder.Options = .default) throws -> Parameters {
        var params = additionalParams ?? [:]
        params[Consts.APIKeys.data] = try json.compactMap { try encodeAttributesAndRelationships(on: $0, options: options) as AnyObject }
        return params
    }
}

// MATK: - Private extensions -

// MARK: - Decoding

private extension Japx.Decoder {
    
    static func decode(jsonApiInput: Parameters, include: String, options: Japx.Decoder.Options) throws -> Parameters {
        let params = include
            .split(separator: ",")
            .map { $0.split(separator: ".") }
        
        let paramsDict = NSMutableDictionary(capacity: Consts.General.dictCapacity)
        for lineArray in params {
            var dict: NSMutableDictionary = paramsDict
            for param in lineArray {
                if let newDict = dict[param] as? NSMutableDictionary {
                    dict = newDict
                } else {
                    let newDict = NSMutableDictionary(capacity: Consts.General.dictCapacity)
                    dict.setObject(newDict, forKey: param as NSCopying)
                    dict = newDict
                }
            }
        }
        
        let dataObjectsArray = try jsonApiInput.array(from: Consts.APIKeys.data) ?? []
        let includedObjectsArray = (try? jsonApiInput.array(from: Consts.APIKeys.included) ?? []) ?? []
        let allObjectsArray = dataObjectsArray + includedObjectsArray
        let allObjects = try allObjectsArray.reduce(into: [TypeIdPair: Parameters]()) { (result, object) in
            result[try object.extractTypeIdPair()] = object
        }
        
        let objects = try dataObjectsArray.map { (dataObject) -> Parameters in
            return try resolve(object: dataObject, allObjects: allObjects, paramsDict: paramsDict, options: options)
        }
        
        var jsonApi = jsonApiInput
        let isObject = jsonApiInput[Consts.APIKeys.data].map { $0 is Parameters } ?? false
        jsonApi[Consts.APIKeys.data] = (objects.count == 1 && isObject) ? objects[0] : objects
        jsonApi.removeValue(forKey: Consts.APIKeys.included)
        return jsonApi
    }
    
    static func decode(jsonApiInput: NSDictionary, options: Japx.Decoder.Options) throws -> NSDictionary {
        let jsonApi = jsonApiInput.mutable
        
        let dataObjectsArray = try jsonApi.array(from: Consts.APIKeys.data) ?? []
        let includedObjectsArray = (try? jsonApi.array(from: Consts.APIKeys.included) ?? []) ?? []
        
        var dataObjects = [TypeIdPair]()
        var objects = [TypeIdPair: NSMutableDictionary]()
        dataObjects.reserveCapacity(dataObjectsArray.count)
        objects.reserveCapacity(dataObjectsArray.count + includedObjectsArray.count)
        
        for dic in dataObjectsArray {
            let typeId = try dic.extractTypeIdPair()
            dataObjects.append(typeId)
            objects[typeId] = dic.mutable
        }
        for dic in includedObjectsArray {
            let typeId = try dic.extractTypeIdPair()
            objects[typeId] = dic.mutable
        }
        
        try resolveAttributes(from: objects)
        try resolveRelationships(from: objects, options: options)
        
        let isObject = jsonApiInput.object(forKey: Consts.APIKeys.data) is NSDictionary
        if isObject && dataObjects.count == 1 {
            jsonApi.setObject(objects[dataObjects[0]]!, forKey: Consts.APIKeys.data as NSCopying)
        } else {
            jsonApi.setObject(dataObjects.map { objects[$0]! }, forKey: Consts.APIKeys.data as NSCopying)
        }
        jsonApi.removeObject(forKey: Consts.APIKeys.included)
        return jsonApi
    }
}

// MARK: - Decoding helper functions

private extension Japx.Decoder {
 
    static func resolve(object: Parameters, allObjects: [TypeIdPair: Parameters], paramsDict: NSDictionary, options: Japx.Decoder.Options) throws -> Parameters {
        var attributes = (try? object.dictionary(for: Consts.APIKeys.attributes)) ?? Parameters()
        attributes[Consts.APIKeys.type] = object[Consts.APIKeys.type]
        attributes[Consts.APIKeys.id] = object[Consts.APIKeys.id]
        
        let relationshipsReferences = object.asDictionary(from: Consts.APIKeys.relationships) ?? Parameters()
        
        
        let extractRelationship = resolveRelationship(
            from: allObjects,
            parseNotIncludedRelationships: options.parseNotIncludedRelationships
        )
        
        let relationships = try paramsDict.allKeys.compactMap({ $0 as? String }).reduce(into: Parameters(), { (result, relationshipsKey) in
            guard let relationship = relationshipsReferences.asDictionary(from: relationshipsKey) else { return }
            guard let otherObjectsData = try relationship.array(from: Consts.APIKeys.data) else {
                result[relationshipsKey] = NSNull()
                return
            }
            let otherObjects = try otherObjectsData
                .map { try $0.extractTypeIdPair() }
                .compactMap(extractRelationship)
                .map { try resolve(
                        object: $0,
                        allObjects: allObjects,
                        paramsDict: try paramsDict.dictionary(for: relationshipsKey),
                        options: options
                    )
                }

            let isObject = relationship[Consts.APIKeys.data].map { $0 is Parameters } ?? false
            if isObject {
                result[relationshipsKey] = (otherObjects.count == 1) ? otherObjects[0] : NSNull()
            } else {
                result[relationshipsKey] = otherObjects
            }
        })
        
        if options.parseNotIncludedRelationships {
            return try attributes.merging(appendAdditionalReferences(from: relationshipsReferences, to: relationships)) { $1 }
        } else {
            return attributes.merging(relationships) { $1 }
        }
    }
    
    static func appendAdditionalReferences(from relationshipsReferences: Parameters, to relationships: Parameters) throws -> Parameters {
        let additionlReferences = try relationshipsReferences.reduce(into: Parameters()) { (result, relationship) in
            guard let relationshipParams = relationship.value as? Parameters else {
                throw JapxError.relationshipNotFound(data: relationship)
            }
            result[relationship.key] = relationshipParams[Consts.APIKeys.data]
        }
        return additionlReferences.merging(relationships) { $1 }
    }
    
    static func resolveAttributes(from objects: [TypeIdPair: NSMutableDictionary]) throws {
        objects.values.forEach { (object) in
            let attributes = try? object.dictionary(for: Consts.APIKeys.attributes)
            attributes?.forEach { object[$0] = $1 }
            object.removeObject(forKey: Consts.APIKeys.attributes)
        }
    }
    
    static func resolveRelationships(from objects: [TypeIdPair: NSMutableDictionary], options: Japx.Decoder.Options) throws {
        
        let extractRelationship = resolveRelationship(
            from: objects,
            parseNotIncludedRelationships: options.parseNotIncludedRelationships
        )
        
        try objects.values.forEach { (object) in
            
            try object.dictionary(for: Consts.APIKeys.relationships, defaultDict: NSDictionary()).forEach { (relationship) in
                
                guard let relationshipParams = relationship.value as? NSDictionary else {
                    throw JapxError.relationshipNotFound(data: relationship)
                }
                
                // Extract type-id pair from single object / array
                guard let others = try relationshipParams.array(from: Consts.APIKeys.data) else {
                    object.setObject(NSNull(), forKey: relationship.key as! NSCopying)
                    return
                }
                
                // Fetch those object from `objects`
                let othersObjects = try others
                    .map { try $0.extractTypeIdPair() }
                    .compactMap(extractRelationship)
                
                // Store relationships
                let isObject = relationshipParams
                    .object(forKey: Consts.APIKeys.data)
                    .map { $0 is NSDictionary } ?? false
                
                if others.count == 1 && isObject {
                    object.setObject(othersObjects.first as Any, forKey: relationship.key as! NSCopying)
                } else {
                    object.setObject(othersObjects, forKey: relationship.key as! NSCopying)
                }
            }
            object.removeObject(forKey: Consts.APIKeys.relationships)
        }
    }

    // In case that relationship object is not in objects list, then check should
    // we fallback to relationship key itself
    static func resolveRelationship(
        from objects: [TypeIdPair: Parameters],
        parseNotIncludedRelationships: Bool
    ) -> ((TypeIdPair) -> Parameters?) {
        if parseNotIncludedRelationships {
            return { objects[$0] ?? $0.asDictionary }
        } else {
            return { objects[$0] }
        }
    }
    
    static func resolveRelationship(
        from objects: [TypeIdPair: NSMutableDictionary],
        parseNotIncludedRelationships: Bool
    ) -> ((TypeIdPair) -> NSMutableDictionary?) {
        if parseNotIncludedRelationships {
            return { objects[$0] ?? $0.asNSDictionary.mutable }
        } else {
            return { objects[$0] }
        }
    }

}

// MARK: - Encoding

private extension Japx.Encoder {
    
    static func encodeAttributesAndRelationships(on jsonObject: Parameters, options: Japx.Encoder.Options) throws -> Parameters {
        var object = jsonObject
        var attributes = Parameters()
        var relationships = Parameters()
        let objectKeys = object.keys
        
        let relationshipExtractor = extractRelationshipData(
            includeMetaToCommonNamespce: options.includeMetaToCommonNamespce
        )
        
        for key in objectKeys where key != Consts.APIKeys.type && key != Consts.APIKeys.id {
            
            if options.includeMetaToCommonNamespce && key == Consts.APIKeys.meta {
                continue
            }
            
            if let array = object.asArray(from: key) {
                let isArrayOfRelationships = array.first?.containsTypeAndId() ?? false
                if !isArrayOfRelationships {
                    // Handle attributes array
                    attributes[key] = array
                    object.removeValue(forKey: key)
                    continue
                }
                let dataArray = try array.map(relationshipExtractor)
                // Handle relationships array
                relationships[key] = [Consts.APIKeys.data: dataArray]
                object.removeValue(forKey: key)
                continue
            }
            if let obj = object.asDictionary(from: key) {
                if !obj.containsTypeAndId() {
                    // Handle attributes object
                    attributes[key] = obj
                    object.removeValue(forKey: key)
                    continue
                }
                let dataObj = try relationshipExtractor(obj)
                // Handle relationship object
                relationships[key] = [Consts.APIKeys.data: dataObj]
                object.removeValue(forKey: key)
                continue
            }
            attributes[key] = object[key]
            object.removeValue(forKey: key)
        }
        object[Consts.APIKeys.attributes] = attributes
        object[Consts.APIKeys.relationships] = relationships
        return object
    }
    
    static func extractRelationshipData(includeMetaToCommonNamespce: Bool) -> (Parameters) throws -> (Any) {
        if !includeMetaToCommonNamespce {
            return { try $0.asDataWithTypeAndId() }
        }
        return { object in
            var params = try object.asDataWithTypeAndId()
            if let meta = object[Consts.APIKeys.meta] {
                params[Consts.APIKeys.meta] = meta
            }
            return params
        }
    }
}

// MARK: - General helper extensions -

extension TypeIdPair: Hashable, Equatable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(id)
    }

    static func == (lhs: TypeIdPair, rhs: TypeIdPair) -> Bool {
        return lhs.type == rhs.type && lhs.id == rhs.id
    }
}

extension TypeIdPair {

    var asNSDictionary: NSDictionary {
        return asDictionary as NSDictionary
    }
    
    var asDictionary: Parameters {
        return [
            Consts.APIKeys.type: type,
            Consts.APIKeys.id: id
        ]
    }

}

private extension Dictionary where Key == String {
    
    func containsTypeAndId() -> Bool {
        return keys.contains(Consts.APIKeys.type) && keys.contains(Consts.APIKeys.id)
    }
    
    func asDataWithTypeAndId() throws -> Parameters {
        guard let type = self[Consts.APIKeys.type], let id = self[Consts.APIKeys.id] else {
            throw JapxError.notFoundTypeOrId(data: self)
        }
        return [Consts.APIKeys.type: type, Consts.APIKeys.id: id]
    }
    
    func extractTypeIdPair() throws -> TypeIdPair {
        if let id = self[Consts.APIKeys.id] as? String, let type = self[Consts.APIKeys.type] as? String {
            return TypeIdPair(type: type, id: id)
        }
        throw JapxError.notFoundTypeOrId(data: self)
    }
    
    func asDictionary(from key: String) -> Parameters? {
        return self[key] as? Parameters
    }
    
    func dictionary(for key: String) throws -> Parameters {
        if let value = self[key] as? Parameters {
            return value
        }
        throw JapxError.notDictionary(data: self, value: self[key])
    }
    
    func asArray(from key: String) -> [Parameters]? {
        return self[key] as? [Parameters]
    }
    
    func array(from key: String) throws -> [Parameters]? {
        let value = self[key]
        if let array = value as? [Parameters] {
            return array
        }
        if let dict = value as? Parameters {
            return [dict]
        }
        if value == nil || value is NSNull {
            return nil
        }
        throw JapxError.cantProcess(data: self)
    }
}

private extension NSDictionary {
    
    var mutable: NSMutableDictionary {
        if #available(iOS 10.0, *) {
            return self as? NSMutableDictionary ?? self.mutableCopy() as! NSMutableDictionary
        } else {
            return self.mutableCopy() as! NSMutableDictionary
        }
    }
    
    func extractTypeIdPair() throws -> TypeIdPair {
        if let id = self.object(forKey: Consts.APIKeys.id) as? String, let type = self.object(forKey: Consts.APIKeys.type) as? String {
            return TypeIdPair(type: type, id: id)
        }
        throw JapxError.notFoundTypeOrId(data: self)
    }
    
    func dictionary(for key: String, defaultDict: NSDictionary) -> NSDictionary {
        return (self.object(forKey: key) as? NSDictionary) ?? defaultDict
    }
    
    func dictionary(for key: String) throws -> NSDictionary {
        if let value = self.object(forKey: key) as? NSDictionary {
            return value
        }
        throw JapxError.notDictionary(data: self, value: self[key])
    }
    
    func array(from key: String) throws -> [NSDictionary]? {
        let value = self.object(forKey: key)
        if let array = value as? [NSDictionary] {
            return array
        }
        if let dict = value as? NSDictionary {
            return [dict]
        }
        if value == nil || value is NSNull {
            return nil
        }
        throw JapxError.cantProcess(data: self)
    }
}
