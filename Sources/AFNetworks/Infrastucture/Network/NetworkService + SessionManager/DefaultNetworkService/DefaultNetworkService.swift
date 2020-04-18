//
//  DefaultNetworkService.swift
//  AFNetwork
//
//  Created by Ali Fakih on 2/24/20.
//  Copyright © 2020 Ali Fakih. All rights reserved.
//

import Foundation

public final class DefaultNetworkService {
    
    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager
    private let logger: NetworkErrorLogger
    
    public init(config: NetworkConfigurable, sessionManager: NetworkSessionManager = DefaultNetworkSessionManager(), logger: NetworkErrorLogger = DefaultNetworkErrorLogger()) {
        self.config = config
        self.sessionManager = sessionManager
        self.logger = logger
    }
    
    private func request(request: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable {
        
        let sessionDataTask = sessionManager.request(request) { (data, urlResponse, requestError) in
            
            if let requestError = requestError {
                var error: NetworkError
                if let response = urlResponse as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }
                
                self.logger.log(error: error)
                completion(.failure(error))
            } else {
               self.logger.log(responseData: data, response: urlResponse)
                completion(.success(data))
            }
        }

        logger.log(request: request)
        return sessionDataTask
    }
    
    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet:
            return .notConnected
        case .cancelled:
            return .cancelled
        default:
            return .generic(error)
        }
    }
}

extension DefaultNetworkService: NetworkService {
    public func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable? {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            return self.request(request: urlRequest, completion: completion)
        } catch {
            completion(.failure(.urlGeneration))
            return nil
        }
    }
    
    
}
