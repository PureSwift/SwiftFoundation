//
//  Integer.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/24/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

public extension Int64 {
    
    func toInt() -> Int? {
        
        // Can't convert to Int if the stored value is larger than the max value of Int
        guard self <= Int64(Int.max) else { return nil }
        
        return Int(self)
    }
}

public extension Int {
    
    func toInt64() -> Int64 {
        
        return Int64(self)
    }
}

public extension UInt16 {
    
    /// Initializes value from two bytes.
    public init(bytes: (UInt8, UInt8)) {
        
        self = unsafeBitCast(bytes, to: UInt16.self)
    }
    
    /// Converts to two bytes. 
    public var bytes: (UInt8, UInt8) {
        
        return unsafeBitCast(self, to: (UInt8, UInt8).self)
    }
}

