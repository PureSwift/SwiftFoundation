//
//  Date.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/28/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// `Date` structs represent a single point in time.
public struct Date: Equatable, Hashable {
    
    // MARK: - Static Properties and Methods
    
    /// The number of seconds from 1 January 1970 to the reference date, 1 January 2001.
    public static var timeIntervalBetween1970AndReferenceDate: SwiftFoundation.TimeInterval { return 978307200.0 }
    
    /**
     Creates and returns a Date value representing a date in the distant future.
     
     The distant future is in terms of centuries.
     */
    public static var distantFuture: SwiftFoundation.Date { return Date(timeIntervalSinceReferenceDate: 63113904000.0) }
    
    /**
     Creates and returns a Date value representing a date in the distant past.
     
     The distant past is in terms of centuries.
     */
    public static var distantPast: SwiftFoundation.Date { return Date(timeIntervalSinceReferenceDate: -63114076800.0) }
    
    /// The interval between 00:00:00 UTC on 1 January 2001 and the current date and time.
    public static var timeIntervalSinceReferenceDate: TimeInterval {
        return self.timeIntervalSince1970 - self.timeIntervalBetween1970AndReferenceDate
    }
        
    // MARK: - Properties
    
    /// The time interval between the date and the reference date (1 January 2001, GMT).
    public var timeIntervalSinceReferenceDate: TimeInterval
    
    /**
     The time interval between the date and the current date and time.
     
     If the date is earlier than the current date and time, the this property’s value is negative.
     
     - SeeAlso: `timeIntervalSince(_:)`
     - SeeAlso: `timeIntervalSince1970`
     - SeeAlso: `timeIntervalSinceReferenceDate`
     */
    public var timeIntervalSinceNow: TimeInterval {
        return timeIntervalSinceReferenceDate - Date.timeIntervalSinceReferenceDate
    }
    
    /**
     The interval between the date object and 00:00:00 UTC on 1 January 1970.
     
     This property’s value is negative if the date object is earlier than 00:00:00 UTC on 1 January 1970.
     
     - SeeAlso: `timeIntervalSince(_:)`
     - SeeAlso: `timeIntervalSinceNow`
     - SeeAlso: `timeIntervalSinceReferenceDate`
     */
    public var timeIntervalSince1970: TimeInterval {
        return timeIntervalSinceReferenceDate + Date.timeIntervalBetween1970AndReferenceDate
    }
    
    // MARK: - Initialization
    
    /// Returns a `Date` initialized to the current date and time.
    public init() {
        self.init(timeIntervalSinceReferenceDate: Date.timeIntervalSinceReferenceDate)
    }
    
    /// Returns an `Date` initialized relative to 00:00:00 UTC on 1 January 2001 by a given number of seconds.
    public init(timeIntervalSinceReferenceDate timeInterval: TimeInterval) {
        self.timeIntervalSinceReferenceDate = timeInterval
    }
    
    /// Returns a `Date` initialized relative to the current date and time by a given number of seconds.
    public init(timeIntervalSinceNow: TimeInterval) {
        self.timeIntervalSinceReferenceDate = timeIntervalSinceNow + Date.timeIntervalSinceReferenceDate
    }
    
    /// Returns a `Date` initialized relative to 00:00:00 UTC on 1 January 1970 by a given number of seconds.
    public init(timeIntervalSince1970: TimeInterval) {
        self.timeIntervalSinceReferenceDate = timeIntervalSince1970 - Date.timeIntervalBetween1970AndReferenceDate
    }
    
    /**
     Returns a `Date` initialized relative to another given date by a given number of seconds.
     
     - Parameter timeInterval: The number of seconds to add to `date`. A negative value means the receiver will be earlier than `date`.
     - Parameter date: The reference date.
     */
    public init(timeInterval: SwiftFoundation.TimeInterval, since date: SwiftFoundation.Date) {
        self.timeIntervalSinceReferenceDate = date.timeIntervalSinceReferenceDate + timeInterval
    }
    
    // MARK: - Methods
    
    /**
     Returns the interval between the receiver and another given date.
     
     - Parameter another: The date with which to compare the receiver.
     
     - Returns: The interval between the receiver and the `another` parameter. If the receiver is earlier than `anotherDate`, the return value is negative. If `anotherDate` is `nil`, the results are undefined.
     
     - SeeAlso: `timeIntervalSince1970`
     - SeeAlso: `timeIntervalSinceNow`
     - SeeAlso: `timeIntervalSinceReferenceDate`
     */
    public func timeIntervalSince(_ date: SwiftFoundation.Date) -> SwiftFoundation.TimeInterval {
        return timeIntervalSinceReferenceDate - date.timeIntervalSinceReferenceDate
    }
    
    /// Return a new `Date` by adding a `TimeInterval` to this `Date`.
    ///
    /// - parameter timeInterval: The value to add, in seconds.
    /// - warning: This only adjusts an absolute value. If you wish to add calendrical concepts like hours, days, months then you must use a `Calendar`. That will take into account complexities like daylight saving time, months with different numbers of days, and more.
    public func addingTimeInterval(_ timeInterval: TimeInterval) -> Date {
        return self + timeInterval
    }
    
    /// Add a `TimeInterval` to this `Date`.
    ///
    /// - parameter timeInterval: The value to add, in seconds.
    /// - warning: This only adjusts an absolute value. If you wish to add calendrical concepts like hours, days, months then you must use a `Calendar`. That will take into account complexities like daylight saving time, months with different numbers of days, and more.
    public mutating func addTimeInterval(_ timeInterval: TimeInterval) {
        self += timeInterval
    }
}

// MARK: - CustomStringConvertible

extension SwiftFoundation.Date: CustomStringConvertible {
    
    public var description: String {
        // TODO: Custom date printing
        return timeIntervalSinceReferenceDate.description
    }
}

// MARK: - CustomDebugStringConvertible

extension SwiftFoundation.Date: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return description
    }
}

// MARK: - Comparable

extension SwiftFoundation.Date: Comparable {
    
    public static func < (lhs: SwiftFoundation.Date, rhs: SwiftFoundation.Date) -> Bool {
        return lhs.timeIntervalSinceReferenceDate < rhs.timeIntervalSinceReferenceDate
    }
    
    public static func > (lhs: SwiftFoundation.Date, rhs: SwiftFoundation.Date) -> Bool {
        return lhs.timeIntervalSinceReferenceDate > rhs.timeIntervalSinceReferenceDate
    }
}

// MARK: - Operators

public extension SwiftFoundation.Date {
    
    /// Returns a `Date` with a specified amount of time added to it.
    static func +(lhs: Date, rhs: TimeInterval) -> Date {
        return Date(timeIntervalSinceReferenceDate: lhs.timeIntervalSinceReferenceDate + rhs)
    }
    
    /// Returns a `Date` with a specified amount of time subtracted from it.
    static func -(lhs: Date, rhs: TimeInterval) -> Date {
        return Date(timeIntervalSinceReferenceDate: lhs.timeIntervalSinceReferenceDate - rhs)
    }
    
    /// Add a `TimeInterval` to a `Date`.
    ///
    /// - warning: This only adjusts an absolute value. If you wish to add calendrical concepts like hours, days, months then you must use a `Calendar`. That will take into account complexities like daylight saving time, months with different numbers of days, and more.
    static func +=(lhs: inout Date, rhs: TimeInterval) {
        lhs = lhs + rhs
    }
    
    /// Subtract a `TimeInterval` from a `Date`.
    ///
    /// - warning: This only adjusts an absolute value. If you wish to add calendrical concepts like hours, days, months then you must use a `Calendar`. That will take into account complexities like daylight saving time, months with different numbers of days, and more.
    static func -=(lhs: inout Date, rhs: TimeInterval) {
        lhs = lhs - rhs
    }

    typealias Stride = TimeInterval

    /// Returns the `TimeInterval` between this `Date` and another given date.
    ///
    /// - returns: The interval between the receiver and the another parameter. If the receiver is earlier than `other`, the return value is negative.
    func distance(to other: Date) -> TimeInterval {
        return other.timeIntervalSince(self)
    }

    /// Creates a new date value by adding a `TimeInterval` to this `Date`.
    ///
    /// - warning: This only adjusts an absolute value. If you wish to add calendrical concepts like hours, days, months then you must use a `Calendar`. That will take into account complexities like daylight saving time, months with different numbers of days, and more.
    func advanced(by n: TimeInterval) -> Date {
        return self.addingTimeInterval(n)
    }
}

// MARK: - Codable

extension Date: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let timestamp = try container.decode(Double.self)
        self.init(timeIntervalSinceReferenceDate: timestamp)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.timeIntervalSinceReferenceDate)
    }
}

// MARK: - Supporting Types

/// Time interval difference between two dates, in seconds.
public typealias TimeInterval = Double
