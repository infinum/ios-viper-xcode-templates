//
//  JapxAlamofire.swift
//  Japx
//
//  Created by Vlaho Poluta on 25/01/2018.
//

import Alamofire
import Foundation

/// `JapxAlamofireError` is the error type returned by JapxAlamofire subspec.
public enum JapxAlamofireError: Error {
    
    /// - invalidKeyPath: Returned when a nested JSON object doesn't exist in parsed JSON:API response by provided `keyPath`.
    case invalidKeyPath(keyPath: String)
}

extension JapxAlamofireError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case let .invalidKeyPath(keyPath: keyPath): return "Nested JSON doesn't exist by keyPath: \(keyPath)."
        }
    }
}

extension Request {
    
    /// Returns a parsed JSON:API object contained in result type.
    ///
    /// - parameter response:       The response from the server.
    /// - parameter data:           The data returned from the server.
    /// - parameter error:          The error already encountered if it exists.
    /// - parameter includeList:    The include list for deserializing JSON:API relationships.
    ///
    /// - returns: The result data type.
    public static func serializeResponseJSONAPI(response: HTTPURLResponse?, data: Data?, error: Error?, includeList: String?) -> Result<Parameters> {
        guard error == nil else { return .failure(error!) }
        
        if let response = response, emptyDataStatusCodes.contains(response.statusCode) { return .success([:]) }
        
        guard let validData = data, validData.count > 0 else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
        }
        
        do {
            let json = try Japx.Decoder.jsonObject(with: validData, includeList: includeList)
            return .success(json)
        } catch {
            return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
        }
    }
}

extension DataRequest {
    
    /// Creates a response serializer that returns a parsed JSON:API object contained in result type.
    ///
    /// - parameter includeList:    The include list for deserializing JSON:API relationships.
    ///
    /// - returns: A JSON:API object response serializer.
    public static func jsonApiResponseSerializer(includeList: String?) -> DataResponseSerializer<Parameters> {
        return DataResponseSerializer { _, response, data, error in
            return Request.serializeResponseJSONAPI(response: response, data: data, error: error, includeList: includeList)
        }
    }
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter queue:             The queue on which the completion handler is dispatched.
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseJSONAPI(queue: DispatchQueue? = nil, includeList: String? = nil, completionHandler: @escaping (DataResponse<Parameters>) -> Void) -> Self {
        return response(
            queue: queue,
            responseSerializer: DataRequest.jsonApiResponseSerializer(includeList: includeList),
            completionHandler: completionHandler
        )
    }
}

extension DownloadRequest {
    
    /// Creates a response serializer that returns a parsed JSON:API object contained in result type.
    ///
    /// - parameter includeList: The include list for deserializing JSON:API relationships.
    ///
    /// - returns: A JSON object response serializer.
    public static func jsonApiResponseSerializer(includeList: String?) -> DownloadResponseSerializer<Parameters>
    {
        return DownloadResponseSerializer { _, response, fileURL, error in
            guard error == nil else { return .failure(error!) }
            
            guard let fileURL = fileURL else {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileNil))
            }
            
            do {
                let data = try Data(contentsOf: fileURL)
                return Request.serializeResponseJSONAPI(response: response, data: data, error: error, includeList: includeList)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileReadFailed(at: fileURL)))
            }
        }
    }
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter queue:             The queue on which the completion handler is dispatched.
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseJSONAPI(queue: DispatchQueue? = nil, includeList: String? = nil, completionHandler: @escaping (DownloadResponse<Parameters>) -> Void) -> Self {
        return response(
            queue: queue,
            responseSerializer: DownloadRequest.jsonApiResponseSerializer(includeList: includeList),
            completionHandler: completionHandler
        )
    }
}

private let emptyDataStatusCodes: Set<Int> = [204, 205]
