//
//  UUID.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/// A representation of universally unique identifiers (UUIDs).
public struct UUID: CustomStringConvertible {
    
    // MARK: - Private Properties
    
    private let internalUUID: uuid_t
    
    private let stringValue: String
    
    // MARK: - Initialization
    
    public init() {
        
        self.internalUUID = UUIDCreateRandom()
        
        self.stringValue = UUIDConvertToString(self.internalUUID)
    }
    
    /*
    public init(string: String) {
        
        
    }
*/
    
    public init(bytes: uuid_t) {
        
        self.internalUUID = bytes
        
        self.stringValue = UUIDConvertToString(self.internalUUID)
    }
    
    // MARK: - CustomStringConvertible
    
    public var description: String { return self.stringValue }
}

// MARK: - Private UUID System Type Functions

private func UUIDCreateRandom() -> uuid_t {
    
    var uuid = uuid_t(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
    
    withUnsafeMutablePointer(&uuid, { (valuePointer: UnsafeMutablePointer<uuid_t>) -> Void in
        
        let bufferType = UnsafeMutablePointer<UInt8>.self
        
        let buffer = unsafeBitCast(valuePointer, bufferType)
        
        uuid_generate(buffer)
    })
    
    return uuid
}

private func UUIDConvertToUUIDString(uuid: uuid_t) -> uuid_string_t {
    
    var uuidCopy = uuid
    
    var uuidString = uuid_string_t(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    
    withUnsafeMutablePointers(&uuidCopy, &uuidString) { (uuidPointer: UnsafeMutablePointer<uuid_t>, uuidStringPointer: UnsafeMutablePointer<uuid_string_t>) -> Void in
        
        let stringBuffer = unsafeBitCast(uuidStringPointer, UnsafeMutablePointer<Int8>.self)
        
        let uuidBuffer = unsafeBitCast(uuidPointer, UnsafeMutablePointer<UInt8>.self)
        
        uuid_unparse(unsafeBitCast(uuidBuffer, UnsafePointer<UInt8>.self), stringBuffer)
    }
    
    return uuidString
}

private func UUIDStringConvertToString(uuidString: uuid_string_t) -> String {
    
    
}

private func UUIDConvertToString(uuid: uuid_t) -> String {
    
    let uuidString = UUIDConvertToUUIDString(uuid)
    
    return UUIDStringConvertToString(uuidString)
}
