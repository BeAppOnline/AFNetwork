//
//  Endpoint.swift
//  AFNetwork
//
//  Created by Ali Fakih on 2/24/20.
//  Copyright © 2020 Ali Fakih. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case delete = "DELETE"
    case post   = "POST"
    case get    = "GET"
    case put    = "PUT"
    case head   = "HEAD"
}

public enum BodyEncoding {
    case jsonSerializationData
    case stringEncodingAscii
}

public enum RequestGenerationError: Error {
    case components
}


public class Endpoint<R>: ResponseRequestable {
    
    public typealias Response = R
    
    public var path: String
    public var isFullPath: Bool
    public var method: HTTPMethod
    public var headerParameter: [String : String]
    public var bodyParameter: [String : Any]
    public var queryParameters: [String : Any]
    public var bodyEncoding: BodyEncoding
    public var responseDecoder: ResponseDecoder
    public var bodyJsonSerializationOption: JSONSerialization.WritingOptions?
    
    public init(path: String,
         isFullPath: Bool = false,
         method: HTTPMethod = .get,
         headerParameters: [String: String] = [:],
         bodyParameters: [String: Any] = [:],
         queryParameters: [String: Any] = [:],
         bodyEncoding: BodyEncoding = .jsonSerializationData,
         responseDecoder: ResponseDecoder = JSONResponseDecoder(),
         bodyJsonSerializationOption: JSONSerialization.WritingOptions? = nil) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.headerParameter = headerParameters
        self.bodyParameter = bodyParameters
        self.queryParameters = queryParameters
        self.bodyEncoding = bodyEncoding
        self.responseDecoder = responseDecoder
        self.bodyJsonSerializationOption = bodyJsonSerializationOption
    }
}

// MARK: - Requestable
public protocol Requestable {
    
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HTTPMethod { get }
    var headerParameter: [String: String] { get }
    var bodyParameter: [String: Any] { get }
    var queryParameters: [String: Any] { get }
    var bodyEncoding: BodyEncoding { get }
    var bodyJsonSerializationOption: JSONSerialization.WritingOptions? { get }
    
    func urlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest
}

extension Requestable {
    func url(with config: NetworkConfigurable) throws -> URL {
        
        let baseURL = config.baseURL.absoluteString.last != "/" ? config.baseURL.absoluteString + "/" : config.baseURL.absoluteString
        let endpoint = isFullPath ? path : baseURL.appending(path)
        
        guard var urlComponents = URLComponents(string: endpoint) else { throw RequestGenerationError.components }
        var urlQueryItems = [URLQueryItem]()
        
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        
        config.queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        
        guard let url = urlComponents.url else { throw RequestGenerationError.components }
        return url
    }
    
    public func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        
        let url = try self.url(with: config)
        var urlRequest = URLRequest(url: url)
        var allHeaders: [String: String] =  config.headers
        
        headerParameter.forEach { allHeaders.updateValue($0.key, forKey: $0.value) }
        
        if !bodyParameter.isEmpty {
            urlRequest.httpBody = encodeBody(bodyParameters: bodyParameter, bodyEncoding: bodyEncoding, with: bodyJsonSerializationOption)
        }
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        return urlRequest
    }
    
    fileprivate func encodeBody(bodyParameters: [String: Any], bodyEncoding: BodyEncoding, with options: JSONSerialization.WritingOptions? = nil) -> Data? {
        switch bodyEncoding {
        case .jsonSerializationData:
            if let option = options {
                
                return try? JSONSerialization.data(withJSONObject: bodyParameters, options: option)
            }
            return try? JSONSerialization.data(withJSONObject: bodyParameters)
        case .stringEncodingAscii:
            return bodyParameters.queryString.data(using: String.Encoding.ascii, allowLossyConversion: true)
        }
    }
}

// MARK: - ResponseRequestable
public protocol ResponseRequestable: Requestable {
    associatedtype Response
    var responseDecoder: ResponseDecoder { get }
}
        
fileprivate extension Dictionary {
    var queryString: String {
        
        return self.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
    }
}
