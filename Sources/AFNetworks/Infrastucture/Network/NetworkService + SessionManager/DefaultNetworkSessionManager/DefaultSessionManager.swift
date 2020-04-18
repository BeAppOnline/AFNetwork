//
//  DefaultSessionManager.swift
//  AFNetwork
//
//  Created by Ali Fakih on 2/24/20.
//  Copyright © 2020 Ali Fakih. All rights reserved.
//

import Foundation

// MARK: - Default Network Session Manager
// Note: If authorization is needed NetworkSessionManager can be implemented by using,
// for example, Alamofire SessionManager with its RequestAdapter and RequestRetrier.
// And it can be injected into NetworkService instead of default one.
public class DefaultNetworkSessionManager: NetworkSessionManager {
    public init() {}
    
    public func request(_ request: URLRequest,
                        completion: @escaping CompletionHandler) -> NetworkCancellable {
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }
}
