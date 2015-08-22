//
//  NSUUID.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import Foundation

public extension UUID {
    
    init(foundation: NSUUID) {
        
        self.init(bytes: foundation.byteValue)
    }
    
    func toFoundation() -> NSUUID {
        
        return NSUUID(byteValue: byteValue)
    }
}

public extension NSUUID {
    
    convenience init(byteValue: uuid_t) {
        
        var value = byteValue
        
        let buffer = withUnsafeMutablePointer(&value, { (valuePointer: UnsafeMutablePointer<uuid_t>) -> UnsafeMutablePointer<UInt8> in
            
            let bufferType = UnsafeMutablePointer<UInt8>.self
            
            return unsafeBitCast(valuePointer, bufferType)
        })
        
        self.init(UUIDBytes: buffer)
    }
    
    var byteValue: uuid_t {
        
        var uuid = uuid_t(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
        
        withUnsafeMutablePointer(&uuid, { (valuePointer: UnsafeMutablePointer<uuid_t>) -> Void in
            
            let bufferType = UnsafeMutablePointer<UInt8>.self
            
            let buffer = unsafeBitCast(valuePointer, bufferType)
            
            self.getUUIDBytes(buffer)
        })
        
        return uuid
    }
    
    var rawValue: String {
        
        return UUIDString
    }
    
    convenience init?(rawValue: String) {
        
        self.init(UUIDString: rawValue)
    }
}
