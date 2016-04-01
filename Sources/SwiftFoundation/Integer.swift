//
//  Integer.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/24/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

public extension Int64 {
    
    func toInt() -> Int? {
        
        // Can't convert to Int if the stored value is larger than the max value of Int
        guard self <= Int64(Int.max) else { return nil }
        
        return Int(self)
    }
}

public extension Int {
    
    func toInt64() -> Int64 {
        
        return Int64(self)
    }
}

