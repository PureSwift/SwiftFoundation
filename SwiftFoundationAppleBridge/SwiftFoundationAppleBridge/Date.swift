//
//  Date.swift
//  SwiftFoundationAppleBridge
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import Foundation
import SwiftFoundation

// MARK: - Operator Overloading

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    
    return lhs.timeIntervalSinceReferenceDate == rhs.timeIntervalSinceReferenceDate
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    
    return lhs.timeIntervalSinceReferenceDate < rhs.timeIntervalSinceReferenceDate
}

public func <=(lhs: NSDate, rhs: NSDate) -> Bool {
    
    return lhs.timeIntervalSinceReferenceDate <= rhs.timeIntervalSinceReferenceDate
}

public func >=(lhs: NSDate, rhs: NSDate) -> Bool {
    
    return lhs.timeIntervalSinceReferenceDate >= rhs.timeIntervalSinceReferenceDate
}

public func >(lhs: NSDate, rhs: NSDate) -> Bool {
    
    return lhs.timeIntervalSinceReferenceDate > rhs.timeIntervalSinceReferenceDate
}

public func -(lhs: NSDate, rhs: NSDate) -> TimeInterval {
    
    return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
}

public func +(lhs: NSDate, rhs: TimeInterval) -> NSDate {
    
    return NSDate(timeIntervalSinceReferenceDate: lhs.timeIntervalSinceReferenceDate + rhs)
}

public func +=(lhs: NSDate, rhs: TimeInterval) -> NSDate {
    
    return lhs + rhs
}