//
//  DataTransferService.swift
//  KooberMVVM-AF
//
//  Created by Ali Fakih on 2/24/20.
//  Copyright © 2020 Ali Fakih. All rights reserved.
//

import Foundation


public enum DataTransferError: Error {
    case noResponse
    case paring(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}

// MARK: - Error Resolver
public protocol DataTransferErrorResolver {
    func resolve(error: NetworkError) -> Error
}

// MARK: - Error Logger
public protocol DataTransferErrorLogger {
    func log(error: Error)
}

// MARK: - Response Decoder
public protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

// MARK: - Data Transfer Service
public protocol DataTransferService {
    typealias CompletionHandler<T> = (Result<T, Error>) -> Void
    
    @discardableResult
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E, completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where E.Response == T
}


// MARK: - Response Decoders
public class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    public init() { }
    public func decode<T: Decodable>(_ data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}

public class RawDataResponseDecoder: ResponseDecoder {
    public init() { }
    
    enum CodingKeys: String, CodingKey {
        case `default` = ""
    }
    public func decode<T: Decodable>(_ data: Data) throws -> T {
        if T.self is Data.Type, let data = data as? T {
            return data
        } else {
            let context = DecodingError.Context(codingPath: [CodingKeys.default], debugDescription: "Expected Data type")
            throw Swift.DecodingError.typeMismatch(T.self, context)
        }
    }
}
