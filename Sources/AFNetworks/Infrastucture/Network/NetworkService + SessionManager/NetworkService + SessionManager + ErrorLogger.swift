//
//  NetworkService.swift
//  KooberMVVM-AF
//
//  Created by Ali Fakih on 2/24/20.
//  Copyright © 2020 Ali Fakih. All rights reserved.
//

import Foundation

// MARK: - Network Error Enum
public enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

extension NetworkError {
    public var isNotFoundError: Bool { return hasStatusCode(404) }
    
    public func hasStatusCode(_ codeError: Int) -> Bool {
        switch self {
        case let .error(code, _):
            return code == codeError
        default: return false
        }
    }
}

// MARK: - Cancellable Protocol
public protocol NetworkCancellable {
        func cancel()
}

extension URLSessionTask: NetworkCancellable { }

// MARK: - Network Service Protocol
public protocol NetworkService {
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    
    func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable?
}

// MARK: - Network Session Manager Protocol
public protocol NetworkSessionManager {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func request(_ urlRequest: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable
}

// MARK: - Network Error Logger
public protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}


