//
//  Data.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/28/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/** Encapsulates data. */
public protocol DataType: CollectionType, ByteValue {
    
    // MARK: - Properties
    
    /** Number of bytes. */
    var count: UInt { get }
    
    /** Data pointer. */
    var byteValue: (UnsafePointer<Void>, UInt) { get }
}

public extension DataType {
    
    var count: UInt {
        
        return byteValue.1
    }
    
    var isEmpty: Bool {
        
        return count == 0
    }
}

public struct Data {
    
    // MARK: - Private Properties
    
    //private var internalValue: UnsafeBufferPointer<UInt8>
    
    
}