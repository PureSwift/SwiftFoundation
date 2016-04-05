//
//  NSUUID.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin.C
#elseif os(Linux)
    import Glibc
    import SwiftFoundation
    import CUUID
#endif

import Foundation

extension UUID: FoundationConvertible {
    
    public init(foundation: NSUUID) {
        
        self.init(byteValue: foundation.byteValue)
    }
    
    public func toFoundation() -> NSUUID {
        
        return NSUUID(byteValue: byteValue)
    }
}

public extension NSUUID {
    
    convenience init(byteValue: uuid_t) {
        
        var value = byteValue
        
        let buffer = withUnsafeMutablePointer(&value, { (valuePointer: UnsafeMutablePointer<uuid_t>) -> UnsafeMutablePointer<UInt8> in
            
            let bufferType = UnsafeMutablePointer<UInt8>.self
            
            return unsafeBitCast(valuePointer, to: bufferType)
        })
        
        self.init(uuidBytes: buffer)
    }
    
    var byteValue: uuid_t {
        
        var uuid = uuid_t(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
        
        withUnsafeMutablePointer(&uuid, { (valuePointer: UnsafeMutablePointer<uuid_t>) -> Void in
            
            let bufferType = UnsafeMutablePointer<UInt8>.self
            
            let buffer = unsafeBitCast(valuePointer, to: bufferType)
            
            self.getBytes(buffer)
        })
        
        return uuid
    }
    
    var rawValue: String {
        
        return uuidString
    }
    
    convenience init?(rawValue: String) {
        
        self.init(uuidString: rawValue)
    }
}



