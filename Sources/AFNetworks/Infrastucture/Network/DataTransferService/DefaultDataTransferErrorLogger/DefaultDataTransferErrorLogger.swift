//
//  DefaultDataTransferErrorLogger.swift
//  KooberMVVM-AF
//
//  Created by Ali Fakih on 2/24/20.
//  Copyright © 2020 Ali Fakih. All rights reserved.
//

import Foundation

public final class DefaultDataTransferErrorLogger: DataTransferErrorLogger {
    public init() { }
    
    public func log(error: Error) {
        #if DEBUG
        print("-------------")
        print("error: \(error)")
        #endif
    }
}
