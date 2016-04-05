//
//  Hexadecimal.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 3/2/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

public extension UInt8 {
    
    func toHexadecimal() -> String {
        
        var string = String(self, radix: 16)
        
        if string.utf8.count == 1 {
            
            string = "0" + string
        }
        
        return string.uppercased()
    }
}