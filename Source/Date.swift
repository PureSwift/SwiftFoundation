//
//  Date.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/28/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

// MARK: - Protocol

/** Date Type */
public protocol DateType: ByteValue, Equatable, Comparable, CustomStringConvertible {
    
    /** Returns the time interval between the date and the reference date (1 January 2001, GMT). */
    var timeIntervalSinceReferenceDate: TimeInterval { get }
    
    /** Creates the date with the current time. */
    init()
    
    /** Creates the date with the specified time interval since the reference date (1 January 2001, GMT). */
    init(timeIntervalSinceReferenceDate: TimeInterval)
    
    /** Creates the date with the specified time interval since 1 January 1970, GMT. */
    init(timeIntervalSince1970: TimeInterval)
}

// MARK: - Protocol Implementation

/** Default implementations */
public extension DateType {
    
    /// Returns the time interval between the current date and 1 January 1970, GMT.
    var timeIntervalSince1970: TimeInterval {
        
        return timeIntervalSinceReferenceDate - TimeIntervalBetween1970AndReferenceDate
    }
    
    func timeIntervalSinceDate(date: Self) -> TimeInterval {
        
        return self - date
    }
    
    var byteValue: TimeInterval {
        
        return self.timeIntervalSinceReferenceDate
    }
    
    var description: String {
        
        return "\(self.timeIntervalSinceReferenceDate)"
    }
}

// MARK: - Implementation

public struct Date: DateType {
    
    // MARK: - Properties
    
    /// Returns the time interval between the date and the reference date (1 January 2001, GMT).
    public let timeIntervalSinceReferenceDate: TimeInterval
    
    // MARK: - Initialization
    
    public init() {
        
        timeIntervalSinceReferenceDate = TimeIntervalSinceReferenceDate()
    }
    
    public init(timeIntervalSinceReferenceDate timeInterval: TimeInterval) {
        
        timeIntervalSinceReferenceDate = timeInterval
    }
    
    public init(timeIntervalSince1970 timeInterval: TimeInterval) {
        
        timeIntervalSinceReferenceDate = timeInterval - TimeIntervalBetween1970AndReferenceDate
    }
}

// MARK: - Operator Overloading

public func == <T: DateType> (lhs: T, rhs: T) -> Bool {
    
    return lhs.timeIntervalSinceReferenceDate == rhs.timeIntervalSinceReferenceDate
}

public func < <T: DateType> (lhs: T, rhs: T) -> Bool {
    
    return lhs.timeIntervalSinceReferenceDate < rhs.timeIntervalSinceReferenceDate
}

public func <= <T: DateType> (lhs: T, rhs: T) -> Bool {
    
    return lhs.timeIntervalSinceReferenceDate <= rhs.timeIntervalSinceReferenceDate
}

public func >= <T: DateType> (lhs: T, rhs: T) -> Bool {
    
    return lhs.timeIntervalSinceReferenceDate >= rhs.timeIntervalSinceReferenceDate
}

public func > <T: DateType> (lhs: T, rhs: T) -> Bool {
    
    return lhs.timeIntervalSinceReferenceDate > rhs.timeIntervalSinceReferenceDate
}

public func - <T: DateType> (lhs: T, rhs: T) -> TimeInterval {
    
    return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
}

public func + <T: DateType> (lhs: T, rhs: TimeInterval) -> T {
    
    return T(timeIntervalSinceReferenceDate: lhs.timeIntervalSinceReferenceDate + rhs)
}

public func += <T: DateType> (lhs: T, rhs: TimeInterval) -> T {
    
    return lhs + rhs
}

// MARK: - Functions

/// Returns the time interval between the current date and the reference date (1 January 2001, GMT). */
public func TimeIntervalSinceReferenceDate() -> TimeInterval {
    
    return TimeIntervalSince1970() - TimeIntervalBetween1970AndReferenceDate
}

/// Returns the time interval between the current date and 1 January 1970, GMT */
public func TimeIntervalSince1970() -> TimeInterval {
    
    var timeStamp = timeval()
    	
    gettimeofday(&timeStamp, nil)
    
    return timeStamp.timeIntervalValue
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

