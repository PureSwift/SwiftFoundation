//
//  Data.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/28/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin.C
#elseif os(Linux)
    import Glibc
#endif

/// Encapsulates data.
public struct Data: ByteValueType, Equatable {
    
    public var byteValue: [Byte]
    
    public init(byteValue: [Byte] = []) {
        
        self.byteValue = byteValue
    }
}

public typealias Byte = UInt8

public extension Data {
    
    /// Initializes ```Data``` from an unsafe byte pointer. 
    ///
    /// - Precondition: The pointer  points to a type exactly a byte long.
    static func from<T: Any>(pointer: UnsafePointer<T>, length: Int) -> Data {
        
        assert(sizeof(pointer.pointee.dynamicType) == sizeof(Byte.self), "Cannot create array of bytes from pointer to \(pointer.pointee.dynamicType) because the type is larger than a single byte.")
        
        var buffer: [UInt8] = [UInt8](repeating: 0, count: length)
        
        memcpy(&buffer, pointer, length)
        
        return Data(byteValue: buffer)
    }
}

// MARK: - Equatable

public func == (lhs: Data, rhs: Data) -> Bool {
    
    guard lhs.byteValue.count == rhs.byteValue.count else { return false }
    
    var bytes1 = lhs.byteValue
    
    var bytes2 = rhs.byteValue
    
    return memcmp(&bytes1, &bytes2, lhs.byteValue.count) == 0
}

// MARK: - Protocol

/// Protocol for converting types to and from data.
public protocol DataConvertible {
    
    /// Attempt to inialize from `Data`.
    init?(data: Data)
    
    /// Convert to data. 
    func toData() -> Data
}


    