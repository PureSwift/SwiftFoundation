//
//  UUID.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/// A representation of universally unique identifiers (UUIDs).
public struct UUID: CustomStringConvertible {
    
    // MARK: - Public Properties
    
    public let stringValue: String
    
    public let byteValue: uuid_t
    
    // MARK: - Initialization
    
    public init() {
        
        self.byteValue = UUIDCreateRandom()
        
        self.stringValue = UUIDConvertToString(self.byteValue)
    }
    
    /*
    public init(string: String) {
        
        
    }
    */
    
    public init(bytes: uuid_t) {
        
        self.byteValue = bytes
        
        self.stringValue = UUIDConvertToString(self.byteValue)
    }
    
    // MARK: - CustomStringConvertible
    
    public var description: String { return self.stringValue }
}

// MARK: - Private UUID System Type Functions

private typealias UUIDStringType = uuid_string_t

private func UUIDCreateRandom() -> uuid_t {
    
    var uuid = uuid_t(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
    
    withUnsafeMutablePointer(&uuid, { (valuePointer: UnsafeMutablePointer<uuid_t>) -> Void in
        
        let bufferType = UnsafeMutablePointer<UInt8>.self
        
        let buffer = unsafeBitCast(valuePointer, bufferType)
        
        uuid_generate(buffer)
    })
    
    return uuid
}

private func UUIDConvertToUUIDString(uuid: uuid_t) -> UUIDStringType {
    
    var uuidCopy = uuid
    
    var uuidString = UUIDStringType(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    
    withUnsafeMutablePointers(&uuidCopy, &uuidString) { (uuidPointer: UnsafeMutablePointer<uuid_t>, uuidStringPointer: UnsafeMutablePointer<UUIDStringType>) -> Void in
        
        let stringBuffer = unsafeBitCast(uuidStringPointer, UnsafeMutablePointer<Int8>.self)
        
        let uuidBuffer = unsafeBitCast(uuidPointer, UnsafeMutablePointer<UInt8>.self)
        
        uuid_unparse(unsafeBitCast(uuidBuffer, UnsafePointer<UInt8>.self), stringBuffer)
    }
    
    return uuidString
}

private func UUIDStringConvertToString(uuidString: UUIDStringType) -> String {
    
    var uuidStringCopy = uuidString
    
    return withUnsafeMutablePointer(&uuidStringCopy, { (valuePointer: UnsafeMutablePointer<UUIDStringType>) -> String in
        
        let bufferType = UnsafeMutablePointer<CChar>.self
        
        let buffer = unsafeBitCast(valuePointer, bufferType)
        
        return String.fromCString(unsafeBitCast(buffer, UnsafePointer<CChar>.self))!
    })
}

private func UUIDConvertToString(uuid: uuid_t) -> String {
    
    let uuidString = UUIDConvertToUUIDString(uuid)
    
    return UUIDStringConvertToString(uuidString)
}
