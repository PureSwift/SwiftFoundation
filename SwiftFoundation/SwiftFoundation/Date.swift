//
//  Date.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/28/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/** Date Type */
public protocol DateType: Equatable, Comparable, CustomStringConvertible {
    
    /** Returns the time interval between the date and the reference date (1 January 2001, GMT). */
    var timeIntervalSinceReferenceDate: TimeInterval { get }
    
    /** Creates the date with the current time. */
    init()
    
    /** Creates the date with the specified time interval since the reference date (1 January 2001, GMT). */
    init(timeIntervalSinceReferenceDate: TimeInterval)
}

/** Default implementations */
public extension DateType {
    
    func timeIntervalSinceDate(date: Self) -> TimeInterval {
        
        return self.timeIntervalSinceReferenceDate - date.timeIntervalSinceReferenceDate
    }
    
    public var description: String {
        
        return "\(self.timeIntervalSinceReferenceDate)"
    }
}

public struct Date: DateType {
    
    // MARK: - Properties
    
    /** Returns the time interval between the date and the reference date (1 January 2001, GMT). */
    public let timeIntervalSinceReferenceDate: TimeInterval
    
    // MARK: - Initialization
    
    public init() {
        
        self.timeIntervalSinceReferenceDate = TimeIntervalSinceReferenceDate()
    }
    
    public init(timeIntervalSinceReferenceDate: TimeInterval) {
        
        self.timeIntervalSinceReferenceDate = timeIntervalSinceReferenceDate
    }
}

// MARK: - Operator Overloading

public func ==(lhs: Date, rhs: Date) -> Bool {
    
    return lhs.timeIntervalSinceReferenceDate == rhs.timeIntervalSinceReferenceDate
}

public func <(lhs: Date, rhs: Date) -> Bool {
    
    return lhs.timeIntervalSinceReferenceDate < rhs.timeIntervalSinceReferenceDate
}

public func <=(lhs: Date, rhs: Date) -> Bool {
    
    return lhs.timeIntervalSinceReferenceDate <= rhs.timeIntervalSinceReferenceDate
}

public func >=(lhs: Date, rhs: Date) -> Bool {
    
    return lhs.timeIntervalSinceReferenceDate >= rhs.timeIntervalSinceReferenceDate
}

public func >(lhs: Date, rhs: Date) -> Bool {
    
    return lhs.timeIntervalSinceReferenceDate > rhs.timeIntervalSinceReferenceDate
}

public func -(lhs: Date, rhs: Date) -> TimeInterval {
    
    return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
}

public func +(lhs: Date, rhs: TimeInterval) -> Date {
    
    return Date(timeIntervalSinceReferenceDate: lhs.timeIntervalSinceReferenceDate + rhs)
}

public func +=(lhs: Date, rhs: TimeInterval) -> Date {
    
    return lhs + rhs
}

// MARK: - Functions

/** Returns the time interval between the current date and the reference date (1 January 2001, GMT). */
public func TimeIntervalSinceReferenceDate() -> TimeInterval {
    
    var timeStamp = timeval()
    
    gettimeofday(&timeStamp, nil)
    
    let secondsSinceReferenceDate = TimeInterval(timeStamp.tv_sec) - TimeIntervalSince1970
    
    let microseconds = (TimeInterval(timeStamp.tv_usec) / TimeInterval(1000000.0))
    
    let timeSinceReferenceDate = secondsSinceReferenceDate + microseconds
    
    return timeSinceReferenceDate
}

// MARK: - Constants

/** Time interval difference between two dates, in seconds. */
public typealias TimeInterval = Double

///
/// Time interval between the unix standard reference date of 1 January 1970 and the OpenStep reference date of 1 January 2001
/// This number comes from:
///
/// ```(((31 years * 365 days) + 8  *(days for leap years)* */) = /* total number of days */ * 24 hours * 60 minutes * 60 seconds)```
///
/// - note: This ignores leap-seconds
public let TimeIntervalSince1970: TimeInterval = 978307200.0
