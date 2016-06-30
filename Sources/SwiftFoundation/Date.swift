//
//  Date.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/28/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin.C
    import struct Foundation.Date
#elseif os(Linux)
    import Glibc
#endif

#if os(Linux) || XcodeLinux
    
    /// `Date` structs represent a single point in time.
    public struct Date: Equatable, Hashable, Comparable, CustomStringConvertible {
        
        // MARK: - Static Properties and Methods
        
        /// The number of seconds from 1 January 1970 to the reference date, 1 January 2001.
        public static let timeIntervalBetween1970AndReferenceDate = 978307200.0
        
        /**
         Creates and returns a Date value representing a date in the distant future.
         
         The distant future is in terms of centuries.
         */
        public static let distantFuture = Date(timeIntervalSinceReferenceDate: 63113904000.0)
        
        /**
         Creates and returns a Date value representing a date in the distant past.
         
         The distant past is in terms of centuries.
         */
        public static let distantPast = Date(timeIntervalSinceReferenceDate: -63114076800.0)
        
        /// The interval between 00:00:00 UTC on 1 January 2001 and the current date and time.
        public static var timeIntervalSinceReferenceDate: TimeInterval {
            
            return try! timeval.timeOfDay().timeInterval - Date.timeIntervalBetween1970AndReferenceDate
        }
        
        // MARK: - Properties
        
        /// The time interval between the date and the reference date (1 January 2001, GMT).
        public var timeIntervalSinceReferenceDate: TimeInterval
        
        /// The time interval between the current date and 1 January 1970, GMT.
        public var timeIntervalsince1970: TimeInterval {
            
            get { return timeIntervalSinceReferenceDate + Date.timeIntervalBetween1970AndReferenceDate }
            
            set { timeIntervalSinceReferenceDate = timeIntervalsince1970 - Date.timeIntervalBetween1970AndReferenceDate }
        }
        
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
        
        public var description: String {
            
            return "\(timeIntervalSinceReferenceDate)"
        }
        
        public var hashValue: Int {
            
            return timeIntervalSinceReferenceDate.hashValue
        }
        
        // MARK: - Initialization
        
        /// Returns a `Date` initialized to the current date and time.
        public init() {
            
            self.timeIntervalSinceReferenceDate = Date.timeIntervalSinceReferenceDate
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
        public init(timeInterval: TimeInterval, since date: Date) {
            
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
        public func timeIntervalSince(_ date: Date) -> TimeInterval {
            
            return timeIntervalSinceReferenceDate - date.timeIntervalSinceReferenceDate
        }
    }
    
    // MARK: - Operators
    
    public func == (lhs: Date, rhs: Date) -> Bool {
        
        return lhs.timeIntervalSinceReferenceDate == rhs.timeIntervalSinceReferenceDate
    }
    
    public func < (lhs: Date, rhs: Date) -> Bool {
        
        return lhs.timeIntervalSinceReferenceDate < rhs.timeIntervalSinceReferenceDate
    }
    
    public func - (lhs: Date, rhs: Date) -> TimeInterval {
        
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    public func + (lhs: Date, rhs: TimeInterval) -> Date {
        
        return Date(timeIntervalSinceReferenceDate: lhs.timeIntervalSinceReferenceDate + rhs)
    }
    
    public func - (lhs: Date, rhs: TimeInterval) -> Date {
        
        return Date(timeIntervalSinceReferenceDate: lhs.timeIntervalSinceReferenceDate - rhs)
    }
    
    public func += (lhs: inout Date, rhs: TimeInterval) {
        
        lhs = lhs + rhs
    }
    
    public func -= (lhs: inout Date, rhs: TimeInterval) {
        
        lhs = lhs - rhs
    }
    
    // MARK: - Supporting Types
    
    /// Time interval difference between two dates, in seconds.
    public typealias TimeInterval = Double

#endif

// MARK: - Darwin

#if (os(OSX) || os(iOS) || os(watchOS) || os(tvOS)) && !XcodeLinux
    
    public typealias Date = Foundation.Date
    
    public func - (lhs: Date, rhs: Date) -> TimeInterval {
        
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
#endif
