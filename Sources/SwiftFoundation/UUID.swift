//
//  UUID.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// A representation of a universally unique identifier (```UUID```).
public struct UUID: ByteValueType, RawRepresentable, CustomStringConvertible {
    
    /// Raw byte type for UUID
    public typealias ByteValue = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
    
    // MARK: - Public Properties
    
    public var byteValue: ByteValue
    
    // MARK: - Initialization
    
    public init() {
        
        self.byteValue = POSIXUUIDCreateRandom()
    }
    
    public init(byteValue: ByteValue) {
        
        self.byteValue = byteValue
    }
}

// MARK: - RawRepresentable

public extension UUID {
    
    init?(rawValue: String) {
        
        guard let uuid = POSIXUUIDConvertStringToUUID(rawValue)
            else { return nil }
        
        self.byteValue = uuid
    }
    
    var rawValue: String {
        
        return POSIXUUIDConvertToString(byteValue)
    }
}
