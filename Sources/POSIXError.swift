//
//  POSIXError.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/22/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#elseif os(Linux)
    import Glibc
#endif

public extension POSIXError {
    
    /// Creates error from C ```errno```.
    static var fromErrorNumber: POSIXError? { return self.init(rawValue: errno) }
}


