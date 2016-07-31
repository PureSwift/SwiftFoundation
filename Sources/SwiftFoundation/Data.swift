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

// MARK: - Linux

#if os(Linux) || XcodeLinux
    
    /// Encapsulates data.
    public struct Data: ByteValue, Equatable, Hashable, CustomStringConvertible, RandomAccessCollection, MutableCollection {
        
        public typealias Index = Int
        public typealias Indices = DefaultRandomAccessIndices<Data>
        
        // MARK: - Properties
        
        fileprivate var _bytes: ContiguousArray<Byte>
        
        public var bytes: [Byte] {
            
            @inline(__always)
            get { return Array(_bytes) }
            
            @inline(__always)
            set { _bytes = ContiguousArray(newValue) }
        }
        
        // MARK: - Initialization
        
        /// Initialize a `Data` with the contents of an Array.
        ///
        /// - parameter bytes: An array of bytes to copy.
        @inline(__always)
        public init(bytes: [Byte] = []) {
            
            _bytes = ContiguousArray(bytes)
        }
        
        /// Initialize a `Data` with the contents of an Array.
        ///
        /// - parameter bytes: An array of bytes to copy.
        @inline(__always)
        public init(bytes: ArraySlice<UInt8>) {
            
            _bytes = ContiguousArray(bytes)
        }
        
        /// Initialize a `Data` with the specified size.
        ///
        /// - parameter capacity: The size of the data.
        @inline(__always)
        public init?(count: Int) {
            
            // Never fails on Linux
            _bytes = ContiguousArray.init(repeating: 0, count: count)
        }
        
        /// Initialize a `Data` with copied memory content.
        ///
        /// - parameter bytes: A pointer to the memory. It will be copied.
        /// - parameter count: The number of bytes to copy.
        @inline(__always)
        public init(bytes pointer: UnsafePointer<Void>, count: Int) {
            
            _bytes = ContiguousArray<UInt8>(repeating: 0, count: count)
            
            memcpy(&bytes, pointer, count)
        }
        
        /// Initialize a `Data` with copied memory content.
        ///
        /// - parameter buffer: A buffer pointer to copy. The size is calculated from `SourceType` and `buffer.count`.
        public init<SourceType>(buffer: UnsafeBufferPointer<SourceType>) {
            
            guard let pointer = buffer.baseAddress
                else { self.init(); return }
            
            self.init(bytes: pointer, count: sizeof(SourceType.self) * buffer.count)
        }
        
        // MARK: - Accessors
        
        public var hashValue: Int {
            
            /// Only hash first 80 bytes
            let hashBytes = bytes.prefix(80)
            
            return Hash(Data(bytes: hashBytes))
        }
        
        public var description: String {
            
            let hexString = bytes.map({ $0.toHexadecimal() }).reduce("", { $0.0 + $0.1 })
            
            return "<" + hexString + ">"
        }
        
        // MARK: - Methods
        
        /// Append data to the data.
        ///
        /// - parameter data: The data to append to this data.
        @inline(__always)
        public mutating func append(_ other: Data) {
            
            _bytes += other._bytes
        }
        
        /// Return a new copy of the data in a specified range.
        ///
        /// - parameter range: The range to copy.
        @inline(__always)
        public func subdata(in range: Range<Index>) -> Data {
            
            return Data(bytes: _bytes[range])
        }
        
        // MARK: - Index and Subscript
        
        /// Sets or returns the byte at the specified index.
        
        public subscript(index: Index) -> Byte {
            
            @inline(__always)
            get { return _bytes[index] }
            
            @inline(__always)
            set { _bytes[index] = newValue }
        }
        
        public subscript(bounds: Range<Int>) -> MutableRandomAccessSlice<Data> {
            
            @inline(__always)
            get { return MutableRandomAccessSlice(base: self, bounds: bounds) }
            
            @inline(__always)
            set { _bytes.replaceSubrange(bounds, with: newValue) }
        }
        
        public var count: Int {
            
            return _bytes.count
        }
        
        /// The start `Index` in the data.
        public var startIndex: Index {
            
            return 0
        }
        
        /// The end `Index` into the data.
        ///
        /// This is the "one-past-the-end" position, and will always be equal to the `count`.
        public var endIndex: Index {
            return count
        }
        
        public func index(before i: Index) -> Index {
            return i - 1
        }
        
        public func index(after i: Index) -> Index {
            return i + 1
        }
        
        /// An iterator over the contents of the data.
        ///
        /// The iterator will increment byte-by-byte.
        public func makeIterator() -> Data.Iterator {
            
            return IndexingIterator(_elements: self)
        }
    }
    
    // MARK: - Equatable
    
    public func == (lhs: Data, rhs: Data) -> Bool {
        
        guard lhs.count == rhs.count else { return false }
        
        var bytes1 = lhs.bytes
        
        var bytes2 = rhs.bytes
        
        return memcmp(&bytes1, &bytes2, lhs.bytes.count) == 0
    }

    // MARK: - Operators
    
    public func + (lhs: Data, rhs: Data) -> Data {
                
        var result = Data()
        
        result._bytes = lhs._bytes + rhs._bytes
        
        return result
    }
    
#endif

// MARK: - Darwin

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    
    extension Foundation.Data: ByteValue {
        
        public typealias ByteValue = [Byte]
        
        public var bytes: [Byte] {
            
            get {
                
                return withUnsafeBytes({ (pointer: UnsafePointer<Byte>) in
                    
                    var bytes = [UInt8](repeating: 0, count: count)
                    
                    memcpy(&bytes, pointer, count)
                    
                    return bytes
                })
            }
            
            set { self = Foundation.Data(bytes: newValue) }
        }
    }
    
    public func + (lhs: Foundation.Data, rhs: Foundation.Data) -> Foundation.Data {
        
        var copy = lhs
        
        copy.append(rhs)
        
        return copy
    }
    
#endif

// MARK: - Supporting Types

public typealias Byte = UInt8

/// Protocol for converting types to and from data.
public protocol DataConvertible {
    
    /// Attempt to inialize from `Data`.
    init?(data: Data)
    
    /// Convert to data. 
    func toData() -> Data
}
