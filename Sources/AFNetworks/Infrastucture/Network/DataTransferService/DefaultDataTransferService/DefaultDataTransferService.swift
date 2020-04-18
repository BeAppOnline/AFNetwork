//
//  DefaultDataTransferService.swift
//  AFNetwork
//
//  Created by Ali Fakih on 2/24/20.
//  Copyright © 2020 Ali Fakih. All rights reserved.
//

import Foundation

public final class DefaultDataTransferService {
    
    private let networkService: NetworkService
    private let errorResolver: DataTransferErrorResolver
    private let errorLogger: DataTransferErrorLogger
    
    public init(with networkService: NetworkService,
         errorResolver: DataTransferErrorResolver = DefaultDataTransferErrorResolver(),
         errorLogger: DataTransferErrorLogger = DefaultDataTransferErrorLogger()) {
        self.networkService = networkService
        self.errorResolver  = errorResolver
        self.errorLogger    = errorLogger
    }
}

extension DefaultDataTransferService: DataTransferService {
    public func request<T: Decodable, E: ResponseRequestable>(with endpoint: E, completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where E.Response == T {
        
        return self.networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                let result: Result<T, Error> = self.decode(data: data, decoder: endpoint.responseDecoder)
                DispatchQueue.main.async { return completion(result) }
            case .failure(let nError):
                self.errorLogger.log(error: nError)
                let error = self.resolve(networkError: nError)
                DispatchQueue.main.async { return completion(.failure(error))}
            }
        }
    }
    
    private func decode<T: Decodable> (data: Data?, decoder: ResponseDecoder) -> Result<T, Error> {
        do {
            guard let data = data else { return .failure(DataTransferError.noResponse)}
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            self.errorLogger.log(error: error)
            return .failure(error)
        }
    }
    
    private func resolve(networkError error: NetworkError) -> DataTransferError {
       let resolvedError = self.errorResolver.resolve(error: error)
       return resolvedError is NetworkError ? .networkFailure(error) : .resolvedNetworkFailure(resolvedError)
   }
}
