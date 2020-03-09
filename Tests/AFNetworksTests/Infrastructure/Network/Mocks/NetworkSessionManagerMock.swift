//
//  NetworkSessionManagerMock.swift
//  AFNetwork
//
//  Created by Ali Fakih on 2/24/20.
//  Copyright © 2020 Ali Fakih. All rights reserved.
//

import Foundation
@testable import AFNetworks

struct NetworkSessionManagerMock: NetworkSessionManager {
    let response: HTTPURLResponse?
    let data: Data?
    let error: Error?
    
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> NetworkCancellable {
        completion(data, response, error)
        if #available(iOS 13, *) {
            let session = URLSession.shared
            return session.dataTask(with: request)
        }else {
            return URLSessionDataTask()
        }
        
    }
}
