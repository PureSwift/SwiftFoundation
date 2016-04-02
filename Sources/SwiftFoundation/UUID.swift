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
    
    /// Creates a random UUID.
    public init() {
        
        self.byteValue = POSIXUUIDCreateRandom()
    }
    
    /// Initializes a UUID with the specified bytes.
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

// MARK: - DataConvertible

extension UUID: DataConvertible {
    
    public init?(data: Data) {
        
        let byteValue = data.byteValue
        
        guard byteValue.count == 16 else { return nil }
        
        self.init(byteValue: (byteValue[0], byteValue[1], byteValue[2], byteValue[3], byteValue[4], byteValue[5], byteValue[6], byteValue[7], byteValue[8], byteValue[9], byteValue[10], byteValue[11], byteValue[12], byteValue[13], byteValue[14], byteValue[15]))
    }
    
    public func toData() -> Data {
        
        return Data(byteValue: [byteValue.0, byteValue.1, byteValue.2, byteValue.3, byteValue.4, byteValue.5, byteValue.6, byteValue.7, byteValue.8, byteValue.9, byteValue.10, byteValue.11, byteValue.12, byteValue.13, byteValue.14, byteValue.15])
    }
}
