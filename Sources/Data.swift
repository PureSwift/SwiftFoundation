//
//  Data.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/28/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// Encapsulates data.

public typealias Data = [Byte]

public typealias Byte = UInt8

public func DataFromBytePointer<T: Any>(pointer: UnsafePointer<T>, length: Int) -> Data  {
    
    assert(sizeof(pointer.memory.dynamicType) == sizeof(Byte.self), "Cannot create array of bytes from pointer to \(pointer.memory.dynamicType) because the type is larger than a single byte.")
    
    var buffer: [UInt8] = [UInt8](count: length, repeatedValue: 0)
    
    memcpy(&buffer, pointer, length)
    
    return buffer
}

    