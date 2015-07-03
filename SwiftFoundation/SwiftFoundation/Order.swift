//
//  Order.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/3/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/** Indicates how items are ordered. */
public enum Order {
    
    case Ascending
    case Same
    case Descending
}

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