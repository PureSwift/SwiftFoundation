//
//  UUID.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// Raw byte type for UUID
public typealias UUIDBytes = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)

/// A representation of a universally unique identifier (```UUID```).
public struct UUID: ByteValueType, RawRepresentable, CustomStringConvertible, FoundationConvertible {
    
    // MARK: - Public Properties
    
    public var byteValue: UUIDBytes
    
    public var rawValue: String {
        
        return POSIXUUIDConvertToString(self.byteValue)
    }
    
    // MARK: - Initialization
    
    public init() {
        
        self.byteValue = POSIXUUIDCreateRandom()
    }
    
    public init?(rawValue: String) {
        
        guard let uuid = POSIXUUIDConvertStringToUUID(rawValue) else {
            
            return nil
        }
        
        self.byteValue = uuid
    }
    
    public init(bytes: UUIDBytes) {
        
        self.byteValue = bytes
    }
}
