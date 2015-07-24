//
//  Data.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import Foundation

extension NSData {
    
    public convenience init(bytes: Data) {
        self.init(bytes: bytes, length: bytes.count)
    }
    
    public func arrayOfBytes() -> Data {
        let count = self.length / sizeof(UInt8)
        var bytesArray = [UInt8](count: count, repeatedValue: 0)
        self.getBytes(&bytesArray, length:count * sizeof(UInt8))
        return bytesArray
    }
}