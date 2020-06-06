//
//  POSIXError.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/22/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#endif

/// Describes an error in the POSIX error domain.
public struct POSIXError: Error {
        
    public typealias Code = POSIXErrorCode
    
    public let code: POSIXErrorCode
    
    public init(code: POSIXErrorCode) {
        self.code = code
    }
}

internal extension POSIXError {
    
    /// Creates error from C ```errno```.
    static func fromErrno(file: StaticString = #file,
                          line: UInt = #line,
                          function: StaticString = #function) -> POSIXError {
        
        guard let code = POSIXErrorCode(rawValue: errno)
            else { fatalError("Invalid POSIX Error \(errno)", file: file, line: line) }
        
        return POSIXError(code: code)
    }
}

/// Wasm or another platform that does not provide POSIXErrorCode
#if arch(wasm32) && (!os(Linux) && !canImport(Darwin) && !os(Windows))

public struct POSIXErrorCode: RawRepresentable, Equatable, Hashable {
    
    public let rawValue: Int32
    
    public init?(rawValue: Int32) {
        self.rawValue = rawValue
    }
}

#endif
