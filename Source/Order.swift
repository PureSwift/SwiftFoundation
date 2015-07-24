//
//  Order.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/3/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// Indicates how items are ordered.
public enum Order: Int {
    
    case Ascending      =  1
    case Same           =  0
    case Descending     = -1
}

// MARK: - Implementation

public extension Comparable {
    
    /** Compares the reciever with another and returns their order. */
    func compare(other: Self) -> Order {
        
        if self < other {
            
            return .Ascending
        }
        
        if self > other {
            
            return .Descending
        }
        
        return .Same
    }
}

