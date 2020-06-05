//
//  Hexadecimal.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 3/2/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

internal extension FixedWidthInteger {
    
    func toHexadecimal() -> String {
        
        var string = String(self, radix: 16)
        while string.utf8.count < (MemoryLayout<Self>.size * 2) {
            string = "0" + string
        }
        return string.uppercased()
    }
}

internal extension UInt8 {
    
    init?<S>(hexadecimal string: S) where S: StringProtocol {
        guard string.count == 2 else { return nil }
        self.init(string, radix: 16)
    }
}

internal extension Array where Element == UInt8 {
    
    init?<S>(hexadecimal string: S) where S: StringProtocol {
        guard string.count % 2 == 0 else { return nil }
        let byteCount = string.count / 2
        self = (0 ..< byteCount).lazy
            .map { string[string.index(string.startIndex, offsetBy: $0 * 2) ..< string.index(string.startIndex, offsetBy: ($0 * 2) + 2)] }
            .compactMap(UInt8.init)
    }
    
    func toHexadecimal() -> String {
        return reduce("") { $0 + $1.toHexadecimal() }
    }
}
