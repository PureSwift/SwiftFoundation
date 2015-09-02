//
//  POSIXError.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/22/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

public extension POSIXError {
    
    /// Creates error from C ```errno```.
    static var fromErrorNumber: POSIXError? { return self.init(rawValue: errno) }
}


