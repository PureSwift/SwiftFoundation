//
//  UUID.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/// A representation of universally unique identifiers (UUIDs).
public struct UUID: CustomStringConvertible {
    
    // MARK: - Private Class Methods
    
    private static func convertToString(internalUUID: uuid_t) -> String {
        
        var cString = CChar()
        
        var mutableUUID = internalUUID
        
        //uuid_unparse(unsafeBitCast(<#T##x: T##T#>, UnsafePointer<Void>.self), unsafeBitCast(<#T##x: T##T#>, UnsafePointer<Void>.self))
        
        return String.fromCString(&cString)!
    }
    
    // MARK: - Private Properties
    
    private let internalUUID: uuid_t
    
    private let stringValue: String
    
    // MARK: - Initialization
    
    public init() {
        
        var uuid = uuid_t(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
        
        withUnsafeMutablePointer(&uuid, { (ptr: UnsafeMutablePointer<uuid_t>) -> Void in
            
            let type = UnsafeMutablePointer<UInt8>.self
            
            let uint8Ptr: UnsafeMutablePointer<UInt8> = unsafeBitCast(ptr, type)
            
            uuid_generate(uint8Ptr)
        })
        
        self.internalUUID = uuid
        
        self.stringValue = UUID.convertToString(self.internalUUID)
    }
    
    /*
    public init(string: String) {
        
        
    }
*/
    
    public init(bytes: uuid_t) {
        
        self.internalUUID = bytes
        
        self.stringValue = UUID.convertToString(self.internalUUID)
    }
    
    // MARK: - CustomStringConvertible
    
    public var description: String { return self.stringValue }
}