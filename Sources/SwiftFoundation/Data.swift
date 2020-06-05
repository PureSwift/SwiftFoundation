//
//  Data.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/28/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if canImport(Darwin)
import Darwin.C
#elseif canImport(Glibc)
import Glibc
#endif

/// Encapsulates data.
@frozen
public struct Data: RandomAccessCollection, MutableCollection, RangeReplaceableCollection, MutableDataProtocol, ContiguousBytes {
    
    // MARK: - Properties
    
    @usableFromInline
    internal private(set) var storage: Storage
    
    // MARK: - Initialization
    
    @inlinable
    internal init(storage: Storage) {
        self.storage = storage
    }
    
    /// Initialize a `Data` with copied memory content.
    ///
    /// - parameter bytes: A pointer to the memory. It will be copied.
    /// - parameter count: The number of bytes to copy.
    @inlinable // This is @inlinable as a trivial initializer.
    public init(bytes: UnsafeRawPointer, count: Int) {
        self.storage = .init(UnsafeRawBufferPointer(start: bytes, count: count))
    }
    
    /// Initialize a `Data` with copied memory content.
    ///
    /// - parameter buffer: A buffer pointer to copy. The size is calculated from `SourceType` and `buffer.count`.
    @inlinable // This is @inlinable as a trivial, generic initializer.
    public init<SourceType>(buffer: UnsafeBufferPointer<SourceType>) {
        self.storage = .init(UnsafeRawBufferPointer(buffer))
    }
    
    /// Initialize a `Data` with copied memory content.
    ///
    /// - parameter buffer: A buffer pointer to copy. The size is calculated from `SourceType` and `buffer.count`.
    @inlinable // This is @inlinable as a trivial, generic initializer.
    public init<SourceType>(buffer: UnsafeMutableBufferPointer<SourceType>) {
        self.storage = .init(UnsafeRawBufferPointer(buffer))
    }
    
    /// Initialize a `Data` with a repeating byte pattern
    ///
    /// - parameter repeatedValue: A byte to initialize the pattern
    /// - parameter count: The number of bytes the data initially contains initialized to the repeatedValue
    @inlinable // This is @inlinable as a convenience initializer.
    public init(repeating repeatedValue: UInt8, count: Int) {
        self.init(count: count)
        if count > 0 {
            self.withUnsafeMutableBytes { (buffer: UnsafeMutableRawBufferPointer) -> Void in
                memset(buffer.baseAddress!, Int32(repeatedValue), buffer.count)
            }
        }
    }
    
    /// Initialize a `Data` with the specified size.
    ///
    /// This initializer doesn't necessarily allocate the requested memory right away. `Data` allocates additional memory as needed, so `capacity` simply establishes the initial capacity. When it does allocate the initial memory, though, it allocates the specified amount.
    ///
    /// This method sets the `count` of the data to 0.
    ///
    /// If the capacity specified in `capacity` is greater than four memory pages in size, this may round the amount of requested memory up to the nearest full page.
    ///
    /// - parameter capacity: The size of the data.
    @inlinable // This is @inlinable as a trivial initializer.
    public init(capacity: Int) {
        self.storage = .init(capacity: capacity)
    }
    
    /// Initialize a `Data` with the specified count of zeroed bytes.
    ///
    /// - parameter count: The number of bytes the data initially contains.
    @inlinable // This is @inlinable as a trivial initializer.
    public init(count: Int) {
        self.storage = .init(count: count)
    }
    
    /// Initialize an empty `Data`.
    @inlinable // This is @inlinable as a trivial initializer.
    public init() {
        self.init(storage: .empty)
    }
    
    // slightly faster paths for common sequences
    @inlinable // This is @inlinable as an important generic funnel point, despite being a non-trivial initializer.
    public init<S: Sequence>(_ elements: S) where S.Element == UInt8 {
        // If the sequence is already contiguous, access the underlying raw memory directly.
        if let contiguous = elements as? ContiguousBytes {
            self.storage = contiguous.withUnsafeBytes { return .init($0) }
            return
        }
        
        // The sequence might still be able to provide direct access to typed memory.
        // NOTE: It's safe to do this because we're already guarding on S's element as `UInt8`. This would not be safe on arbitrary sequences.
        let storage = elements.withContiguousStorageIfAvailable { Storage(UnsafeRawBufferPointer($0)) }
        
        if let storage = storage {
            self.storage = storage
        } else {
            // slow path
            self.storage = .buffer(.init(elements))
        }
    }
    
    // MARK: - Properties and Functions

    @inlinable // This is @inlinable as trivially forwarding.
    public mutating func reserveCapacity(_ minimumCapacity: Int) {
        storage.reserveCapacity(minimumCapacity)
    }
    
    /// The number of bytes in the data.
    @inlinable // This is @inlinable as trivially forwarding.
    public var count: Int {
        get { return storage.count }
        /*
        set {
            precondition(newValue >= 0, "count must not be negative")
            storage.count = newValue
        }*/
    }

    @inlinable // This is @inlinable as trivially computable.
    public var regions: CollectionOfOne<Data> {
        return CollectionOfOne(self)
    }
    
    @inlinable // This is @inlinable as a generic, trivially forwarding function.
    public func withUnsafeBytes<ResultType>(_ body: (UnsafeRawBufferPointer) throws -> ResultType) rethrows -> ResultType {
        return try storage.withUnsafeBytes(body)
    }
    
    @inlinable // This is @inlinable as a generic, trivially forwarding function.
    public mutating func withUnsafeMutableBytes<ResultType>(_ body: (UnsafeMutableRawBufferPointer) throws -> ResultType) rethrows -> ResultType {
        return try storage.withUnsafeMutableBytes(body)
    }
    
    // MARK: -
    // MARK: Copy Bytes
    
    /// Copy the contents of the data to a pointer.
    ///
    /// - parameter pointer: A pointer to the buffer you wish to copy the bytes into.
    /// - parameter count: The number of bytes to copy.
    /// - warning: This method does not verify that the contents at pointer have enough space to hold `count` bytes.
    @inlinable // This is @inlinable as trivially forwarding.
    public func copyBytes(to pointer: UnsafeMutablePointer<UInt8>, count: Int) {
        precondition(count >= 0, "count of bytes to copy must not be negative")
        if count == 0 { return }
        _copyBytesHelper(to: UnsafeMutableRawPointer(pointer), from: startIndex..<(startIndex + count))
    }
    
    @inlinable // This is @inlinable as trivially forwarding.
    internal func _copyBytesHelper(to pointer: UnsafeMutableRawPointer, from range: Range<Int>) {
        if range.isEmpty { return }
        storage.copyBytes(to: pointer, from: range)
    }
    
    /// Copy a subset of the contents of the data to a pointer.
    ///
    /// - parameter pointer: A pointer to the buffer you wish to copy the bytes into.
    /// - parameter range: The range in the `Data` to copy.
    /// - warning: This method does not verify that the contents at pointer have enough space to hold the required number of bytes.
    @inlinable // This is @inlinable as trivially forwarding.
    public func copyBytes(to pointer: UnsafeMutablePointer<UInt8>, from range: Range<Index>) {
        _copyBytesHelper(to: pointer, from: range)
    }
    
    // Copy the contents of the data into a buffer.
    ///
    /// This function copies the bytes in `range` from the data into the buffer. If the count of the `range` is greater than `MemoryLayout<DestinationType>.stride * buffer.count` then the first N bytes will be copied into the buffer.
    /// - precondition: The range must be within the bounds of the data. Otherwise `fatalError` is called.
    /// - parameter buffer: A buffer to copy the data into.
    /// - parameter range: A range in the data to copy into the buffer. If the range is empty, this function will return 0 without copying anything. If the range is nil, as much data as will fit into `buffer` is copied.
    /// - returns: Number of bytes copied into the destination buffer.
    @inlinable // This is @inlinable as generic and reasonably small.
    public func copyBytes<DestinationType>(to buffer: UnsafeMutableBufferPointer<DestinationType>, from range: Range<Index>? = nil) -> Int {
        let cnt = count
        guard cnt > 0 else { return 0 }
        
        let copyRange : Range<Index>
        if let r = range {
            guard !r.isEmpty else { return 0 }
            copyRange = r.lowerBound..<(r.lowerBound + Swift.min(buffer.count * MemoryLayout<DestinationType>.stride, r.upperBound - r.lowerBound))
        } else {
            copyRange = 0..<Swift.min(buffer.count * MemoryLayout<DestinationType>.stride, cnt)
        }
        
        guard !copyRange.isEmpty else { return 0 }
        
        _copyBytesHelper(to: buffer.baseAddress!, from: copyRange)
        return copyRange.upperBound - copyRange.lowerBound
    }
    
    @inlinable // This is @inlinable as a generic, trivially forwarding function.
    internal mutating func _append<SourceType>(_ buffer : UnsafeBufferPointer<SourceType>) {
        if buffer.isEmpty { return }
        storage.append(contentsOf: UnsafeRawBufferPointer(buffer))
    }
    
    @inlinable // This is @inlinable as a generic, trivially forwarding function.
    public mutating func append(_ bytes: UnsafePointer<UInt8>, count: Int) {
        if count == 0 { return }
        _append(UnsafeBufferPointer(start: bytes, count: count))
    }
    
    public mutating func append(_ other: Data) {
        guard other.count > 0 else { return }
        other.withUnsafeBytes { (buffer: UnsafeRawBufferPointer) in
            storage.append(contentsOf: buffer)
        }
    }
    
    /// Append a buffer of bytes to the data.
    ///
    /// - parameter buffer: The buffer of bytes to append. The size is calculated from `SourceType` and `buffer.count`.
    @inlinable // This is @inlinable as a generic, trivially forwarding function.
    public mutating func append<SourceType>(_ buffer : UnsafeBufferPointer<SourceType>) {
        _append(buffer)
    }

    @inlinable // This is @inlinable as trivially forwarding.
    public mutating func append(contentsOf bytes: [UInt8]) {
        bytes.withUnsafeBufferPointer { (buffer: UnsafeBufferPointer<UInt8>) -> Void in
            _append(buffer)
        }
    }
    
    @inlinable // This is @inlinable as an important generic funnel point, despite being non-trivial.
    public mutating func append<S: Sequence>(contentsOf elements: S) where S.Element == UInt8 {
        // If the sequence is already contiguous, access the underlying raw memory directly.
        if let contiguous = elements as? ContiguousBytes {
            contiguous.withUnsafeBytes {
                storage.append(contentsOf: $0)
            }
            return
        }

        // The sequence might still be able to provide direct access to typed memory.
        // NOTE: It's safe to do this because we're already guarding on S's element as `UInt8`. This would not be safe on arbitrary sequences.
        var appended = false
        elements.withContiguousStorageIfAvailable {
            storage.append(contentsOf: UnsafeRawBufferPointer($0))
            appended = true
        }

        guard !appended else { return }
        
        // inefficient path, forget inline storage
        var buffer: Data.Buffer
        switch storage {
        case .empty:
            buffer = .init()
        case let .inline(inline):
            buffer = .init(inline)
        case let .buffer(bufffer):
            buffer = bufffer
        }
        buffer.append(contentsOf: elements)
        self.storage = .buffer(buffer)
    }
    
    /// Return a new copy of the data in a specified range.
    ///
    /// - parameter range: The range to copy.
    public func subdata(in range: Range<Index>) -> Data {
        if isEmpty || range.upperBound - range.lowerBound == 0 {
            return Data()
        }
        let slice = self[range]

        return slice.withUnsafeBytes { (buffer: UnsafeRawBufferPointer) -> Data in
            return Data(bytes: buffer.baseAddress!, count: buffer.count)
        }
    }
    
    public func advanced(by amount: Int) -> Data {
        let length = count - amount
        precondition(length > 0)
        return withUnsafeBytes { (ptr: UnsafeRawBufferPointer) -> Data in
            return Data(bytes: ptr.baseAddress!.advanced(by: amount), count: length)
        }
    }
    
    // MARK: -
    // MARK: Index and Subscript
    
    /// Sets or returns the byte at the specified index.
    @inlinable // This is @inlinable as trivially forwarding.
    public subscript(index: Index) -> UInt8 {
        get {
            return storage[index]
        }
        set(newValue) {
            storage[index] = newValue
        }
    }
    
    @inlinable // This is @inlinable as trivially forwarding.
    public subscript(bounds: Range<Index>) -> Data {
        get {
            return storage[bounds]
        }
        set {
            replaceSubrange(bounds, with: newValue)
        }
    }
    
    @inlinable // This is @inlinable as a generic, trivially forwarding function.
    public subscript<R: RangeExpression>(_ rangeExpression: R) -> Data
        where R.Bound: FixedWidthInteger {
        get {
            let lower = R.Bound(startIndex)
            let upper = R.Bound(endIndex)
            let range = rangeExpression.relative(to: lower..<upper)
            let start = Int(range.lowerBound)
            let end = Int(range.upperBound)
            let r: Range<Int> = start..<end
            return storage[r]
        }
        set {
            let lower = R.Bound(startIndex)
            let upper = R.Bound(endIndex)
            let range = rangeExpression.relative(to: lower..<upper)
            let start = Int(range.lowerBound)
            let end = Int(range.upperBound)
            let r: Range<Int> = start..<end
            replaceSubrange(r, with: newValue)
        }
        
    }
    
    /// The start `Index` in the data.
    @inlinable // This is @inlinable as trivially forwarding.
    public var startIndex: Index {
        get {
            return storage.startIndex
        }
    }
    
    /// The end `Index` into the data.
    ///
    /// This is the "one-past-the-end" position, and will always be equal to the `count`.
    @inlinable // This is @inlinable as trivially forwarding.
    public var endIndex: Index {
        get {
            return storage.endIndex
        }
    }
    
    @inlinable // This is @inlinable as trivially computable.
    public func index(before i: Index) -> Index {
        return i - 1
    }
    
    @inlinable // This is @inlinable as trivially computable.
    public func index(after i: Index) -> Index {
        return i + 1
    }
    
    @inlinable // This is @inlinable as trivially computable.
    public var indices: Range<Int> {
        get {
            return startIndex..<endIndex
        }
    }
}

// MARK: - Equatable

extension Data: Equatable {
    
    /// Returns `true` if the two `Data` arguments are equal.
    @inlinable // This is @inlinable as emission into clients is safe -- the concept of equality on Data will not change.
    public static func ==(d1 : Data, d2 : Data) -> Bool {
        let length1 = d1.count
        if length1 != d2.count {
            return false
        }
        if length1 > 0 {
            return d1.withUnsafeBytes { (b1: UnsafeRawBufferPointer) in
                return d2.withUnsafeBytes { (b2: UnsafeRawBufferPointer) in
                    return memcmp(b1.baseAddress!, b2.baseAddress!, b2.count) == 0
                }
            }
        }
        return true
    }
}

// MARK: - Hashable

extension Data: Hashable {
    
    /// The hash value for the data.
    @inline(never) // This is not inlinable as emission into clients could cause cross-module inconsistencies if they are not all recompiled together.
    public func hash(into hasher: inout Hasher) {
        storage.hash(into: &hasher)
    }
}

// MARK: - Sequence

extension Data: Sequence {
    
    /// An iterator over the contents of the data.
    ///
    /// The iterator will increment byte-by-byte.
    @inlinable // This is @inlinable as trivially computable.
    public func makeIterator() -> IndexingIterator<Self> {
        return IndexingIterator(_elements: self)
    }
}

// MARK: - CustomStringConvertible

extension Data: CustomStringConvertible {
    
    /// A human-readable description for the data.
    public var description: String {
        return "\(self.count) bytes"
    }
}

// MARK: - CustomDebugStringConvertible

extension Data: CustomDebugStringConvertible {
    
    /// A human-readable debug description for the data.
    public var debugDescription: String {
        return self.description
    }
}

// MARK: - CustomReflectable

extension Data: CustomReflectable {
    
    public var customMirror: Mirror {
        let nBytes = self.count
        var children: [(label: String?, value: Any)] = []
        children.append((label: "count", value: nBytes))
        
        self.withUnsafeBytes { (bytes : UnsafeRawBufferPointer) in
            children.append((label: "pointer", value: bytes.baseAddress!))
        }
        
        // Minimal size data is output as an array
        if nBytes < 64 {
            children.append((label: "bytes", value: Array(self[startIndex..<Swift.min(nBytes + startIndex, endIndex)])))
        }
        
        let m = Mirror(self, children:children, displayStyle: Mirror.DisplayStyle.struct)
        return m
    }
}

// MARK: - Codable

extension Data: Codable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        // It's more efficient to pre-allocate the buffer if we can.
        if let count = container.count {
            self.init(count: count)
            
            // Loop only until count, not while !container.isAtEnd, in case count is underestimated (this is misbehavior) and we haven't allocated enough space.
            // We don't want to write past the end of what we allocated.
            for i in 0 ..< count {
                let byte = try container.decode(UInt8.self)
                self[i] = byte
            }
        } else {
            self.init()
        }
        
        while !container.isAtEnd {
            var byte = try container.decode(UInt8.self)
            self.append(&byte, count: 1)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try withUnsafeBytes { (buffer: UnsafeRawBufferPointer) in
            try container.encode(contentsOf: buffer)
        }
    }
}

// MARK: - Supporting Types

public extension Data {
    
    typealias Index = Int
    typealias Indices = Range<Int>
    typealias Element = UInt8
}

// MARK: - Buffer

internal extension Data {
    
    @usableFromInline
    typealias Buffer = ContiguousArray<UInt8>
}

internal extension Data.Buffer {
    
    @usableFromInline
    init(_ inline: Data.Inline) {
        self.init()
        self.reserveCapacity(inline.count)
        /// FIXME: Improve
        //self.append(contentsOf: inline)
        self = inline.withUnsafeBytes { Data.Buffer($0) }
    }
    
    @inlinable
    var range: Range<Int> {
        return startIndex ..< endIndex
    }
}

// MARK: - Storage

internal extension Data {
    
    @usableFromInline
    enum Storage {
        
        case empty
        case inline(Data.Inline)
        case buffer(Buffer)
    }
}

internal extension Data.Storage {
    
    @inlinable // This is @inlinable as a trivial initializer.
    init(_ buffer: UnsafeRawBufferPointer) {
        if buffer.count == 0 {
            self = .empty
        } else if Data.Inline.canStore(count: buffer.count) {
            self = .inline(Data.Inline(buffer))
        } else {
            self = .buffer(Data.Buffer(buffer))
        }
    }
    
    @inlinable // This is @inlinable as a trivial initializer.
    init(capacity: Int) {
        if capacity == 0 {
            self = .empty
        } else if Data.Inline.canStore(count: capacity) {
            self = .inline(Data.Inline())
        } else {
            var buffer = Data.Buffer()
            buffer.reserveCapacity(capacity)
            self = .buffer(buffer)
        }
    }
    
    @inlinable // This is @inlinable as a trivial initializer.
    init(count: Int) {
        if count == 0 {
            self = .empty
        } else if Data.Inline.canStore(count: count) {
            self = .inline(Data.Inline(count: count))
        } else {
            self = .buffer(Data.Buffer(repeating: 0x00, count: count))
        }
    }
    
    @usableFromInline // This is not @inlinable as it is a non-trivial, non-generic function.
    mutating func reserveCapacity(_ minimumCapacity: Int) {
        guard minimumCapacity > 0 else { return }
        switch self {
        case .empty:
            if Data.Inline.canStore(count: minimumCapacity) {
                self = .inline(Data.Inline())
            } else {
                var buffer = Data.Buffer()
                buffer.reserveCapacity(minimumCapacity)
                self = .buffer(buffer)
            }
        case .inline(let inline):
            guard minimumCapacity > inline.capacity else { return }
            // we know we are going to be heap promoted
            var buffer = Data.Buffer()
            buffer.reserveCapacity(minimumCapacity)
            self = .buffer(buffer)
        case .buffer(var buffer):
            guard minimumCapacity > buffer.capacity else { return }
            self = .empty // make sure ARC has the buffer uniquely referenced
            buffer.reserveCapacity(minimumCapacity)
            self = .buffer(buffer)
        }
    }
    
    @inlinable // This is @inlinable as reasonably small.
    var count: Int {
        get {
            switch self {
            case .empty: return 0
            case .inline(let inline): return inline.count
            case .buffer(let buffer): return buffer.count
            }
        }/*
        set {
            // HACK: The definition of this inline function takes an inout reference to self, giving the optimizer a unique referencing guarantee.
            //       This allows us to avoid excessive retain-release traffic around modifying enum values, and inlining the function then avoids the additional frame.
            @inline(__always)
            func apply(_ representation: inout Data.Storage, _ newValue: Int) -> Data.Storage? {
                switch representation {
                case .empty:
                    if newValue == 0 {
                        return nil
                    } else if Data.Inline.canStore(count: newValue) {
                        return .inline(Data.Inline(count: newValue))
                    } else {
                        return .buffer(Data.Buffer(repeating: 0x00, count: newValue))
                    }
                case .inline(var inline):
                    if newValue == 0 {
                        return .empty
                    } else if Data.Inline.canStore(count: newValue) {
                        guard inline.count != newValue else { return nil }
                        inline.count = newValue
                        return .inline(inline)
                    } else {
                        var buffer = Data.Buffer(inline)
                        buffer.count = newValue
                        return .buffer(buffer)
                    }
                case .buffer(var buffer):
                    if newValue == 0 && buffer.startIndex == 0 {
                        return .empty
                    } else if buffer.startIndex == 0 && Data.Inline.canStore(count: newValue) {
                        return .inline(buffer.withUnsafeBytes { Data.Inline($0) })
                    } else {
                        guard buffer.count != newValue else { return nil}
                        representation = .empty
                        buffer.count = newValue
                        return .buffer(buffer)
                    }
                }
            }

            if let rep = apply(&self, newValue) {
                self = rep
            }
        }*/
    }
    
    @inlinable // This is @inlinable as a generic, trivially forwarding function.
    func withUnsafeBytes<Result>(_ apply: (UnsafeRawBufferPointer) throws -> Result) rethrows -> Result {
        switch self {
        case .empty:
            let empty = Data.Inline()
            return try empty.withUnsafeBytes(apply)
        case .inline(let inline):
            return try inline.withUnsafeBytes(apply)
        case .buffer(let buffer):
            return try buffer.withUnsafeBytes(apply)
        }
    }
    
    @inlinable // This is @inlinable as a generic, trivially forwarding function.
    mutating func withUnsafeMutableBytes<Result>(_ apply: (UnsafeMutableRawBufferPointer) throws -> Result) rethrows -> Result {
        switch self {
        case .empty:
            var empty = Data.Inline()
            return try empty.withUnsafeMutableBytes(apply)
        case .inline(var inline):
            defer { self = .inline(inline) }
            return try inline.withUnsafeMutableBytes(apply)
        case .buffer(var buffer):
            self = .empty
            defer { self = .buffer(buffer) }
            return try buffer.withUnsafeMutableBytes(apply)
        }
    }

    @inlinable // This is @inlinable as reasonably small.
    mutating func append(contentsOf buffer: UnsafeRawBufferPointer) {
        switch self {
        case .empty:
            self = Data.Storage(buffer)
        case .inline(var inline):
            if Data.Inline.canStore(count: inline.count + buffer.count) {
                inline.append(contentsOf: buffer)
                self = .inline(inline)
            } else {
                var newBuffer = Data.Buffer(inline)
                newBuffer.append(contentsOf: buffer)
                self = .buffer(newBuffer)
            }
        case .buffer(var buffer):
            self = .empty
            defer { self = .buffer(buffer) }
            buffer.append(contentsOf: buffer)
        }
    }
    
    @inlinable // This is @inlinable as trivially forwarding.
    subscript(index: Data.Index) -> UInt8 {
        get {
            switch self {
            case .empty: preconditionFailure("index \(index) out of range of 0")
            case .inline(let inline): return inline[index]
            case .buffer(let buffer): return buffer[index]
            }
        }
        set {
            switch self {
            case .empty: preconditionFailure("index \(index) out of range of 0")
            case .inline(var inline):
                inline[index] = newValue
                self = .inline(inline)
            case .buffer(var buffer):
                self = .empty // for ARC, to keep unique reference count
                buffer[index] = newValue
                self = .buffer(buffer)
            }
        }
    }
    
    @inlinable // This is @inlinable as reasonably small.
    subscript(bounds: Range<Data.Index>) -> Data {
        get {
            switch self {
            case .empty:
                precondition(bounds.lowerBound == 0 && (bounds.upperBound - bounds.lowerBound) == 0, "Range \(bounds) out of bounds 0..<0")
                return Data()
            case .inline(let inline):
                precondition(bounds.upperBound <= inline.count, "Range \(bounds) out of bounds 0..<\(inline.count)")
                if bounds.lowerBound == 0 {
                    var newInline = inline
                    newInline.count = bounds.upperBound
                    return Data(storage: .inline(newInline))
                } else {
                    var newInline = Data.Inline()
                    inline.withUnsafeBytes { newInline.append(contentsOf: UnsafeRawBufferPointer(rebasing: $0[bounds])) }
                    return Data(storage: .inline(newInline))
                }
            case .buffer(let buffer):
                precondition(buffer.startIndex <= bounds.lowerBound, "Range \(bounds) out of bounds \(buffer.range)")
                precondition(bounds.lowerBound <= buffer.endIndex, "Range \(bounds) out of bounds \(buffer.range)")
                precondition(buffer.startIndex <= bounds.upperBound, "Range \(bounds) out of bounds \(buffer.range)")
                precondition(bounds.upperBound <= buffer.endIndex, "Range \(bounds) out of bounds \(buffer.range)")
                if bounds.lowerBound == 0 && bounds.upperBound == 0 {
                    return Data()
                } else if Data.Inline.canStore(count: bounds.count) {
                    var newInline = Data.Inline()
                    buffer.withUnsafeBytes { newInline.append(contentsOf: UnsafeRawBufferPointer(rebasing: $0[bounds])) }
                    return Data(storage: .inline(newInline))
                } else {
                    var newBuffer = Data.Buffer()
                    newBuffer.reserveCapacity(bounds.count)
                    newBuffer.append(contentsOf: buffer[bounds])
                    return Data(storage: .buffer(newBuffer))
                }
            }
        }
    }

    @inlinable // This is @inlinable as trivially forwarding.
    var startIndex: Int {
        switch self {
        case .empty: return 0
        case .inline: return 0
        case .buffer(let buffer): return buffer.startIndex
        }
    }

    @inlinable // This is @inlinable as trivially forwarding.
    var endIndex: Int {
        switch self {
        case .empty: return 0
        case .inline(let inline): return inline.count
        case .buffer(let buffer): return buffer.endIndex
        }
    }
    
    @inlinable // This is @inlinable as trivially forwarding.
    func copyBytes(to pointer: UnsafeMutableRawPointer, from range: Range<Int>) {
        switch self {
        case .empty:
            precondition(range.lowerBound == 0 && range.upperBound == 0, "Range \(range) out of bounds 0..<0")
            return
        case .inline(let inline):
            inline.copyBytes(to: pointer, from: range)
        case .buffer(let buffer):
            buffer.withUnsafeBytes {
                let cnt = Swift.min($0.count, range.upperBound - range.lowerBound)
                guard cnt > 0 else { return }
                pointer.copyMemory(from: $0.baseAddress!.advanced(by: range.lowerBound), byteCount: cnt)
            }
        }
    }
    
    @inline(__always) // This should always be inlined into Data.hash(into:).
    func hash(into hasher: inout Hasher) {
        switch self {
        case .empty:
            hasher.combine(0)
        case .inline(let inline):
            inline.hash(into: &hasher)
        case .buffer(let buffer):
            buffer.hash(into: &hasher)
        }
    }
}

// MARK: - Inline

internal extension Data {
    
    // A small inline buffer of bytes suitable for stack-allocation of small data.
        // Inlinability strategy: everything here should be inlined for direct operation on the stack wherever possible.
        @usableFromInline
        @frozen
        struct Inline {
    #if arch(x86_64) || arch(arm64) || arch(s390x) || arch(powerpc64) || arch(powerpc64le)
            @usableFromInline typealias Buffer = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
                                                  UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) //len  //enum
            @usableFromInline var bytes: Buffer
    #elseif arch(i386) || arch(arm) || arch(wasm32)
            @usableFromInline typealias Buffer = (UInt8, UInt8, UInt8, UInt8,
                                                  UInt8, UInt8) //len  //enum
            @usableFromInline var bytes: Buffer
    #else
        #error("This architecture isn't known. Add it to the 32-bit or 64-bit line.")
    #endif
            @usableFromInline var length: UInt8

            @inlinable // This is @inlinable as trivially computable.
            static func canStore(count: Int) -> Bool {
                return count <= MemoryLayout<Buffer>.size
            }

            @inlinable // This is @inlinable as a convenience initializer.
            init(_ srcBuffer: UnsafeRawBufferPointer) {
                self.init(count: srcBuffer.count)
                if srcBuffer.count > 0 {
                    Swift.withUnsafeMutableBytes(of: &bytes) { dstBuffer in
                        dstBuffer.baseAddress?.copyMemory(from: srcBuffer.baseAddress!, byteCount: srcBuffer.count)
                    }
                }
            }

            @inlinable // This is @inlinable as a trivial initializer.
            init(count: Int = 0) {
                assert(count <= MemoryLayout<Buffer>.size)
    #if arch(x86_64) || arch(arm64) || arch(s390x) || arch(powerpc64) || arch(powerpc64le)
                bytes = (UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0))
    #elseif arch(i386) || arch(arm) || arch(wasm32)
                bytes = (UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0))
    #else
        #error("This architecture isn't known. Add it to the 32-bit or 64-bit line.")
    #endif
                length = UInt8(count)
            }

            @inlinable // This is @inlinable as trivially computable.
            var capacity: Int {
                return MemoryLayout<Buffer>.size
            }

            @inlinable // This is @inlinable as trivially computable.
            var count: Int {
                get {
                    return Int(length)
                }
                set(newValue) {
                    assert(newValue <= MemoryLayout<Buffer>.size)
                    length = UInt8(newValue)
                }
            }

            @inlinable // This is @inlinable as trivially computable.
            var startIndex: Int {
                return 0
            }

            @inlinable // This is @inlinable as trivially computable.
            var endIndex: Int {
                return count
            }

            @inlinable // This is @inlinable as a generic, trivially forwarding function.
            func withUnsafeBytes<Result>(_ apply: (UnsafeRawBufferPointer) throws -> Result) rethrows -> Result {
                let count = Int(length)
                return try Swift.withUnsafeBytes(of: bytes) { (rawBuffer) throws -> Result in
                    return try apply(UnsafeRawBufferPointer(start: rawBuffer.baseAddress, count: count))
                }
            }

            @inlinable // This is @inlinable as a generic, trivially forwarding function.
            mutating func withUnsafeMutableBytes<Result>(_ apply: (UnsafeMutableRawBufferPointer) throws -> Result) rethrows -> Result {
                let count = Int(length)
                return try Swift.withUnsafeMutableBytes(of: &bytes) { (rawBuffer) throws -> Result in
                    return try apply(UnsafeMutableRawBufferPointer(start: rawBuffer.baseAddress, count: count))
                }
            }

            @inlinable // This is @inlinable as tribially computable.
            mutating func append(byte: UInt8) {
                let count = self.count
                assert(count + 1 <= MemoryLayout<Buffer>.size)
                Swift.withUnsafeMutableBytes(of: &bytes) { $0[count] = byte }
                self.length += 1
            }

            @inlinable // This is @inlinable as trivially computable.
            mutating func append(contentsOf buffer: UnsafeRawBufferPointer) {
                guard buffer.count > 0 else { return }
                assert(count + buffer.count <= MemoryLayout<Buffer>.size)
                let cnt = count
                _ = Swift.withUnsafeMutableBytes(of: &bytes) { rawBuffer in
                    rawBuffer.baseAddress?.advanced(by: cnt).copyMemory(from: buffer.baseAddress!, byteCount: buffer.count)
                }

                length += UInt8(buffer.count)
            }

            @inlinable // This is @inlinable as trivially computable.
            subscript(index: Index) -> UInt8 {
                get {
                    assert(index <= MemoryLayout<Buffer>.size)
                    precondition(index < length, "index \(index) is out of bounds of 0..<\(length)")
                    return Swift.withUnsafeBytes(of: bytes) { rawBuffer -> UInt8 in
                        return rawBuffer[index]
                    }
                }
                set(newValue) {
                    assert(index <= MemoryLayout<Buffer>.size)
                    precondition(index < length, "index \(index) is out of bounds of 0..<\(length)")
                    Swift.withUnsafeMutableBytes(of: &bytes) { rawBuffer in
                        rawBuffer[index] = newValue
                    }
                }
            }

            @inlinable // This is @inlinable as trivially computable.
            mutating func resetBytes(in range: Range<Index>) {
                assert(range.lowerBound <= MemoryLayout<Buffer>.size)
                assert(range.upperBound <= MemoryLayout<Buffer>.size)
                precondition(range.lowerBound <= length, "index \(range.lowerBound) is out of bounds of 0..<\(length)")
                if count < range.upperBound {
                    count = range.upperBound
                }

                let _ = Swift.withUnsafeMutableBytes(of: &bytes) { rawBuffer in
                  memset(rawBuffer.baseAddress!.advanced(by: range.lowerBound), 0, range.upperBound - range.lowerBound)
                }
            }

            @usableFromInline // This is not @inlinable as it is a non-trivial, non-generic function.
            mutating func replaceSubrange(_ subrange: Range<Index>, with replacementBytes: UnsafeRawPointer?, count replacementLength: Int) {
                assert(subrange.lowerBound <= MemoryLayout<Buffer>.size)
                assert(subrange.upperBound <= MemoryLayout<Buffer>.size)
                assert(count - (subrange.upperBound - subrange.lowerBound) + replacementLength <= MemoryLayout<Buffer>.size)
                precondition(subrange.lowerBound <= length, "index \(subrange.lowerBound) is out of bounds of 0..<\(length)")
                precondition(subrange.upperBound <= length, "index \(subrange.upperBound) is out of bounds of 0..<\(length)")
                let currentLength = count
                let resultingLength = currentLength - (subrange.upperBound - subrange.lowerBound) + replacementLength
                let shift = resultingLength - currentLength
                Swift.withUnsafeMutableBytes(of: &bytes) { mutableBytes in
                    /* shift the trailing bytes */
                    let start = subrange.lowerBound
                    let length = subrange.upperBound - subrange.lowerBound
                    if shift != 0 {
                        memmove(mutableBytes.baseAddress!.advanced(by: start + replacementLength), mutableBytes.baseAddress!.advanced(by: start + length), currentLength - start - length)
                    }
                    if replacementLength != 0 {
                        memmove(mutableBytes.baseAddress!.advanced(by: start), replacementBytes!, replacementLength)
                    }
                }
                count = resultingLength
            }

            @inlinable // This is @inlinable as trivially computable.
            func copyBytes(to pointer: UnsafeMutableRawPointer, from range: Range<Int>) {
                precondition(startIndex <= range.lowerBound, "index \(range.lowerBound) is out of bounds of \(startIndex)..<\(endIndex)")
                precondition(range.lowerBound <= endIndex, "index \(range.lowerBound) is out of bounds of \(startIndex)..<\(endIndex)")
                precondition(startIndex <= range.upperBound, "index \(range.upperBound) is out of bounds of \(startIndex)..<\(endIndex)")
                precondition(range.upperBound <= endIndex, "index \(range.upperBound) is out of bounds of \(startIndex)..<\(endIndex)")

                Swift.withUnsafeBytes(of: bytes) {
                    let cnt = Swift.min($0.count, range.upperBound - range.lowerBound)
                    guard cnt > 0 else { return }
                    pointer.copyMemory(from: $0.baseAddress!.advanced(by: range.lowerBound), byteCount: cnt)
                }
            }

            @inline(__always) // This should always be inlined into _Representation.hash(into:).
            func hash(into hasher: inout Hasher) {
                // **NOTE**: this uses `count` (an Int) and NOT `length` (a UInt8)
                //           Despite having the same value, they hash differently. InlineSlice and LargeSlice both use `count` (an Int); if you combine the same bytes but with `length` over `count`, you can get a different hash.
                //
                // This affects slices, which are InlineSlice and not Data.Inline:
                //
                //   let d = Data([0xFF, 0xFF])                // Data.Inline
                //   let s = Data([0, 0xFF, 0xFF]).dropFirst() // InlineSlice
                //   assert(s == d)
                //   assert(s.hashValue == d.hashValue)
                hasher.combine(count)

                Swift.withUnsafeBytes(of: bytes) {
                    // We have access to the full byte buffer here, but not all of it is meaningfully used (bytes past self.length may be garbage).
                    let bytes = UnsafeRawBufferPointer(start: $0.baseAddress, count: self.count)
                    hasher.combine(bytes: bytes)
                }
            }
        }
}
