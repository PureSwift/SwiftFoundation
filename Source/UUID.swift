//
//  UUID.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/// A representation of a universally unique identifier (```UUID```).
public struct UUID: ByteValue, RawRepresentable, CustomStringConvertible {
    
    // MARK: - Public Properties
    
    public var byteValue: uuid_t
    
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
    
    public init(bytes: uuid_t) {
        
        self.byteValue = bytes
    }
}
