//
//  UUID.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/// A representation of universally unique identifiers (UUIDs).
public struct UUID: RawRepresentable, Equatable, CustomStringConvertible {
    
    // MARK: - Public Properties
    
    public let rawValue: String
    
    public let byteValue: uuid_t
    
    // MARK: - Initialization
    
    public init() {
        
        self.byteValue = UUIDCreateRandom()
        
        self.rawValue = UUIDConvertToString(self.byteValue)
    }
    
    public init(bytes: uuid_t) {
        
        self.byteValue = bytes
        
        self.rawValue = UUIDConvertToString(self.byteValue)
    }
    
    public init?(rawValue: String) {
        
        guard let uuid = UUIDConvertStringToUUID(rawValue) else {
            
            return nil
        }
        
        self.rawValue = rawValue
        
        self.byteValue = uuid
    }
    
    public var description: String { return self.rawValue }
}

// MARK: - Operator Overloading

public func ==(lhs: UUID, rhs: UUID) -> Bool {
    
    return lhs.rawValue == rhs.rawValue
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

private func UUIDConvertToString(uuid: uuid_t) -> String {
    
    let uuidString = UUIDConvertToUUIDString(uuid)
    
    return UUIDStringConvertToString(uuidString)
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

private func UUIDConvertStringToUUID(string: String) -> uuid_t? {
    
    let uuidPointer = UnsafeMutablePointer<uuid_t>.alloc(1)
    defer { uuidPointer.dealloc(1) }
    
    guard uuid_parse(string, unsafeBitCast(uuidPointer, UnsafeMutablePointer<UInt8>.self)) != -1 else {
        
        return nil
    }
    
    return uuidPointer.memory
}
