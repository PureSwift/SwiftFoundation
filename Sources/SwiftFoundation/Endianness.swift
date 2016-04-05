//
//  Endianness.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 2/29/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

/// Number can be converted to little / big endian.
public protocol EndianConvertible: Equatable {
    
    var littleEndian: Self { get }
    
    var bigEndian: Self { get }
}

extension Int: EndianConvertible { }
extension UInt16: EndianConvertible { }
extension Int16: EndianConvertible { }
extension UInt32: EndianConvertible { }
extension Int32: EndianConvertible { }
extension UInt64: EndianConvertible { }
extension Int64: EndianConvertible { }

public extension EndianConvertible {
    
    /// Converts the number to the current endianness.
    var currentEndian: Self {
        
        return isBigEndian ? bigEndian : littleEndian
    }
}

public let isBigEndian = 10.bigEndian == 10
