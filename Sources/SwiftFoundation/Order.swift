//
//  Order.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/3/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// Indicates how items are ordered.
public enum Order: Int {
    
    case ascending      = -1
    case same           =  0
    case descending     =  1
}

// MARK: - Implementation

public extension Comparable {
    
    /** Compares the reciever with another and returns their order. */
    func compare(_ other: Self) -> Order {
        
        if self < other {
            
            return .ascending
        }
        
        if self > other {
            
            return .descending
        }
        
        return .same
    }
}

