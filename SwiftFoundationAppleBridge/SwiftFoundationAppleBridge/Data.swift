//
//  Data.swift
//  SwiftFoundationAppleBridge
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import Foundation

public extension NSData {
    
    /** Number of bytes. */
    var count: UInt {
        
        return UInt(length)
    }
    
    /** Data pointer. */
    var byteValue: (UnsafePointer<Void>, UInt) {
        
        return (bytes, count)
    }
}