//
//  BackwardsCompatibility.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 4/5/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

// Swift 2.2 compatibility
#if !swift(>=3.0)
    
    public typealias ErrorProtocol = ErrorType
    
    public typealias OpaquePointer = COpaquePointer

    public typealias Collection = CollectionType
    
    public typealias Sequence = SequenceType
    
    public typealias Integer = IntegerType

    public extension Sequence {
        public typealias Generator = Iterator
    }
    
    public extension String {
    
        @inline(__always)
        func uppercased() { return uppercaseString }
    
        init?(validatingUTF8 cString: UnsafePointer<CChar>) {
    
            self = Swift.String.fromCString(cString)
        }
    }
    
    public extension UnsafeMutablePointer {
    
        init(allocatingCapacity count: Int) {
    
            self = self.alloc(count)
        }
    
        func deallocateCapacity(count: Int) {
    
            self.dealloc(count)
        }
    
        public var pointee: Memory { }
    }

#endif
