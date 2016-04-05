//
//  NSData.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin.C
#elseif os(Linux)
    import Glibc
    import SwiftFoundation
#endif

import Foundation

extension Data: FoundationConvertible {
    
    public init(foundation: NSData) {
        
        let count = foundation.length / sizeof(UInt8)
        
        var bytesArray = [UInt8] (repeating: 0, count: count)
        
        foundation.getBytes(&bytesArray, length:count * sizeof(UInt8))
        
        self.init(byteValue: bytesArray)
    }
    
    public func toFoundation() -> NSData {
        
        return NSData(bytes: self.byteValue, length: self.byteValue.count)
    }
}
