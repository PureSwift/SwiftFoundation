//
//  ByteValueType.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/3/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// Stores a primitive value. 
///
/// Useful for Swift wrappers for C primitives.
public protocol ByteValueType {
    
    associatedtype ByteValue
    
    /// Returns the primitive type. 
    var byteValue: ByteValue { get }
    
    init(byteValue: ByteValue)
}