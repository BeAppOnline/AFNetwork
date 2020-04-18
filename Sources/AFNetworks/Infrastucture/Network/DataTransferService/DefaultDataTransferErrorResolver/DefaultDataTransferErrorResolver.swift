//
//  DefaultDataTransferErrorResolver.swift
//  AFNetwork
//
//  Created by Ali Fakih on 2/24/20.
//  Copyright © 2020 Ali Fakih. All rights reserved.
//

import Foundation

public class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
    public init() { }
    public func resolve(error: NetworkError) -> Error {
        return error
    }
}
