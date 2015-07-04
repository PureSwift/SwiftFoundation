//
//  ByteValue.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/3/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/** Stores a primitive value. Useful for Swift wrappers for C primitives. */
public protocol ByteValue {
    
    typealias ByteValueType
    
    var byteValue: ByteValueType { get }
}