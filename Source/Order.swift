//
//  Order.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/3/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/// Indicates how items are ordered.
public enum Order: Int, Comparable, Equatable {
    
    case Ascending      =  1
    case Same           =  0
    case Descending     = -1
}

// MARK: - Operator Overloading

public func < (lhs: Order, rhs: Order) -> Bool {
    
    return lhs.rawValue < rhs.rawValue
}

public func <= (lhs: Order, rhs: Order) -> Bool {
    
    return lhs.rawValue <= rhs.rawValue
}

public func >= (lhs: Order, rhs: Order) -> Bool {
    
    return lhs.rawValue >= rhs.rawValue
}

public func > (lhs: Order, rhs: Order) -> Bool {
    
    return lhs.rawValue > rhs.rawValue
}

// MARK: - Swift Extension

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

