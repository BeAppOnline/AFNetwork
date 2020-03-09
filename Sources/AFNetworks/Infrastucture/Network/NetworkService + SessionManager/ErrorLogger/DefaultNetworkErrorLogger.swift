//
//  File.swift
//  KooberMVVM-AF
//
//  Created by Ali Fakih on 2/24/20.
//  Copyright © 2020 Ali Fakih. All rights reserved.
//

import Foundation

public final class DefaultNetworkErrorLogger: NetworkErrorLogger {
    
    public init() { }
    
    public func log(request: URLRequest) {
        #if DEBUG
        print("-------------")
        print("request: \(request.url!)")
        print("headers: \(request.allHTTPHeaderFields!)")
        print("method: \(request.httpMethod!)")
        if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
            print("body: \(String(describing: result))")
        }
        if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            print("body: \(String(describing: resultString))")
        }
        #endif
    }
    
    public func log(responseData data: Data?, response: URLResponse?) {
        #if DEBUG
        guard let data = data else { return }
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            print("responseData: \(String(describing: dataDict))")
        }
        #endif
    }
    
    public func log(error: Error) {
        #if DEBUG
        print("error: \(error)")
        #endif
    }
}
