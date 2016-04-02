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
        
        if isBigEndian {
            
            return bigEndian
            
        } else {
            
            return littleEndian
        }
    }
}

public let isBigEndian = 10.bigEndian == 10

public extension UInt16 {
    
    /// Initializes value from two little endian ordered bytes. 
    public init(littleEndian value: (UInt8, UInt8)) {
        
        self = (UInt16(value.0).littleEndian + UInt16(value.1).bigEndian).currentEndian
    }
    
    public var littleEndianBytes: (UInt8, UInt8) {
        
        let value = self.littleEndian
        
        let lowerByte = value & 0xff
        let higherByte = value >> 8
        
        return (UInt8(truncatingBitPattern: lowerByte), UInt8(truncatingBitPattern: higherByte))
    }
}
