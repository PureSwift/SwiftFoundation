//
//  ComparisonResult.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/30/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

public enum ComparisonResult: Int {
    
    case orderedAscending = -1
    case orderedSame
    case orderedDescending
}

// MARK: - Implementation

public extension Comparable {
    
    /// Compares the reciever with another and returns their order.
    func compare(_ other: Self) -> ComparisonResult {
        if self < other {
            return .orderedAscending
        }
        if self > other {
            return .orderedDescending
        }
        return .orderedSame
    }
}
