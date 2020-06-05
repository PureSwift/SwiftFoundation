//
//  POSIXTime.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/19/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if canImport(Darwin)
import Darwin.C
#elseif canImport(Glibc)
import Glibc
#endif

// MARK: - Date

public extension Date {
    
    /// The interval between 00:00:00 UTC on 1 January 2001 and the current date and time.
    static var timeIntervalSinceReferenceDate: TimeInterval {
        do { return try timeval.timeOfDay().timeInterval - Date.timeIntervalBetween1970AndReferenceDate }
        catch { fatalError("Unable to load current time") }
    }
    
    /// Returns a `Date` initialized to the current date and time.
    init() {
        self.timeIntervalSinceReferenceDate = Date.timeIntervalSinceReferenceDate
    }
}

// MARK: - POSIX Time

internal extension timeval {
    
    static func timeOfDay() throws -> timeval {
        
        var timeStamp = timeval()
        
        guard gettimeofday(&timeStamp, nil) == 0
            else { throw POSIXError.fromErrno() }
        
        return timeStamp
    }
    
    init(timeInterval: SwiftFoundation.TimeInterval) {
        
        let (integerValue, decimalValue) = modf(timeInterval)
        
        let million: SwiftFoundation.TimeInterval = 1000000.0
        
        let microseconds = decimalValue * million
        
        self.init(tv_sec: Int(integerValue), tv_usec: POSIXMicroseconds(microseconds))
    }
    
    var timeInterval: SwiftFoundation.TimeInterval {
        
        let secondsSince1970 = SwiftFoundation.TimeInterval(self.tv_sec)
        
        let million: SwiftFoundation.TimeInterval = 1000000.0
        
        let microseconds = SwiftFoundation.TimeInterval(self.tv_usec) / million
        
        return secondsSince1970 + microseconds
    }
}

internal extension timespec {
    
    init(timeInterval: SwiftFoundation.TimeInterval) {
        
        let (integerValue, decimalValue) = modf(timeInterval)
        
        let billion: SwiftFoundation.TimeInterval = 1000000000.0
        
        let nanoseconds = decimalValue * billion
        
        self.init(tv_sec: .init(integerValue), tv_nsec: .init(nanoseconds))
    }
    
    var timeInterval: SwiftFoundation.TimeInterval {
        
        let secondsSince1970 = SwiftFoundation.TimeInterval(self.tv_sec)
        
        let billion: SwiftFoundation.TimeInterval = 1000000000.0
        
        let nanoseconds = SwiftFoundation.TimeInterval(self.tv_nsec) / billion
        
        return secondsSince1970 + nanoseconds
    }
}

internal extension tm {
    
    init(utcSecondsSince1970 seconds: time_t) {
        
        var seconds = seconds
        
        // don't free!
        // The return value points to a statically allocated struct which might be overwritten by subsequent calls to any of the date and time functions.
        // http://linux.die.net/man/3/gmtime
        let timePointer = gmtime(&seconds)!
        
        self = timePointer.pointee
    }
}

// MARK: - Cross-Platform Support

#if canImport(Darwin)
internal typealias POSIXMicroseconds = __darwin_suseconds_t
#else

#if arch(wasm32)
internal typealias POSIXMicroseconds = Int32
#else
internal typealias POSIXMicroseconds = __suseconds_t
#endif
    
internal func modf(value: Double) -> (Double, Double) {
    
    var integerValue: Double = 0
    
    let decimalValue = modf(value, &integerValue)
    
    return (decimalValue, integerValue)
}
    
#endif
