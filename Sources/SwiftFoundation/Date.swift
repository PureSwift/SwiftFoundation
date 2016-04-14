//
//  Date.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/28/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin.C
#elseif os(Linux)
    import Glibc
#endif

/// Represents a point in time.
public struct Date: Equatable, Comparable, CustomStringConvertible {
    
    // MARK: - Properties
    
    /// The time interval between the date and the reference date (1 January 2001, GMT).
    public var sinceReferenceDate: TimeInterval
    
    /// The time interval between the current date and 1 January 1970, GMT.
    public var since1970: TimeInterval {
        
        get { return sinceReferenceDate + TimeIntervalBetween1970AndReferenceDate }
        
        set { sinceReferenceDate = since1970 - TimeIntervalBetween1970AndReferenceDate }
    }
    
    /// Returns the difference between two dates.
    public func timeIntervalSince(date: Date) -> TimeInterval {
        
        return self - date
    }
    
    public var description: String {
        
        return "\(sinceReferenceDate)"
    }
    
    // MARK: - Initialization
    
    /// Creates the date with the current time.
    public init() {
        
        sinceReferenceDate = TimeIntervalSinceReferenceDate()
    }
    
    /// Creates the date with the specified time interval since the reference date (1 January 2001, GMT).
    public init(sinceReferenceDate timeInterval: TimeInterval) {
        
        sinceReferenceDate = timeInterval
    }
    
    /// Creates the date with the specified time interval since 1 January 1970, GMT.
    public init(since1970 timeInterval: TimeInterval) {
        
        sinceReferenceDate = timeInterval - TimeIntervalBetween1970AndReferenceDate
    }
}

// MARK: - Operator Overloading

public func == (lhs: Date, rhs: Date) -> Bool {
    
    return lhs.sinceReferenceDate == rhs.sinceReferenceDate
}

public func < (lhs: Date, rhs: Date) -> Bool {
    
    return lhs.sinceReferenceDate < rhs.sinceReferenceDate
}

public func <= (lhs: Date, rhs: Date) -> Bool {
    
    return lhs.sinceReferenceDate <= rhs.sinceReferenceDate
}

public func >= (lhs: Date, rhs: Date) -> Bool {
    
    return lhs.sinceReferenceDate >= rhs.sinceReferenceDate
}

public func > (lhs: Date, rhs: Date) -> Bool {
    
    return lhs.sinceReferenceDate > rhs.sinceReferenceDate
}

public func - (lhs: Date, rhs: Date) -> TimeInterval {
    
    return lhs.sinceReferenceDate - rhs.sinceReferenceDate
}

public func + (lhs: Date, rhs: TimeInterval) -> Date {
    
    return Date(sinceReferenceDate: lhs.sinceReferenceDate + rhs)
}

public func += (lhs: inout Date, rhs: TimeInterval) {
    
    lhs = lhs + rhs
}

public func - (lhs: Date, rhs: TimeInterval) -> Date {
    
    return Date(sinceReferenceDate: lhs.sinceReferenceDate - rhs)
}

public func -= (lhs: inout Date, rhs: TimeInterval) {
    
    lhs = lhs - rhs
}

// MARK: - Functions

/// Returns the time interval between the current date and the reference date (1 January 2001, GMT).
public func TimeIntervalSinceReferenceDate() -> TimeInterval {
    
    return TimeIntervalSince1970() - TimeIntervalBetween1970AndReferenceDate
}

/// Returns the time interval between the current date and 1 January 1970, GMT
public func TimeIntervalSince1970() -> TimeInterval {
    
    return try! timeval.timeOfDay().timeIntervalValue
}

// MARK: - Constants

/// Time interval difference between two dates, in seconds.
public typealias TimeInterval = Double

///
/// Time interval between the Unix standard reference date of 1 January 1970 and the OpenStep reference date of 1 January 2001
/// This number comes from:
///
/// ```(((31 years * 365 days) + 8  *(days for leap years)* */) = /* total number of days */ * 24 hours * 60 minutes * 60 seconds)```
///
/// - note: This ignores leap-seconds
public let TimeIntervalBetween1970AndReferenceDate: TimeInterval = 978307200.0

