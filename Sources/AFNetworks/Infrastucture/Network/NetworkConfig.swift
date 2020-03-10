//
//  NetworkConfig.swift
//  KooberMVVM-AF
//
//  Created by Ali Fakih on 2/24/20.
//  Copyright © 2020 Ali Fakih. All rights reserved.
//

import Foundation

// MARK: - Network Configuration Protocol
public protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}

// MARK: - Default Configuration 
public struct ApiDataNetworkConfig: NetworkConfigurable {
    
    public var baseURL: URL
    public var headers: [String : String]
    public var queryParameters: [String : String]
    
    public init(baseURL: URL, headers: [String: String] = [:], queryParameters: [String: String] = [:]) {
        self.baseURL = baseURL
        self.headers = headers
        self.queryParameters = queryParameters
    }
}
