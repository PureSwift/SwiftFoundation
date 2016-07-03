//
//  POSIXTime.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/19/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin.C
#elseif os(Linux)
    import Glibc
#endif

public extension timeval {
    
    static func timeOfDay() throws -> timeval {
        
        var timeStamp = timeval()
        
        guard gettimeofday(&timeStamp, nil) == 0
            else { throw POSIXError.fromErrno! }
        
        return timeStamp
    }
    
    init(timeInterval: TimeInterval) {
        
        let (integerValue, decimalValue) = modf(timeInterval)
        
        let million: TimeInterval = 1000000.0
        
        let microseconds = decimalValue * million
        
        self.init(tv_sec: Int(integerValue), tv_usec: POSIXMicroseconds(microseconds))
    }
    
    var timeInterval: TimeInterval {
        
        let secondsSince1970 = TimeInterval(self.tv_sec)
        
        let million: TimeInterval = 1000000.0
        
        let microseconds = TimeInterval(self.tv_usec) / million
        
        return secondsSince1970 + microseconds
    }
}

public extension timespec {
    
    init(timeInterval: TimeInterval) {
        
        let (integerValue, decimalValue) = modf(timeInterval)
        
        let billion: TimeInterval = 1000000000.0
        
        let nanoseconds = decimalValue * billion
        
        self.init(tv_sec: Int(integerValue), tv_nsec: Int(nanoseconds))
    }
    
    var timeInterval: TimeInterval {
        
        let secondsSince1970 = TimeInterval(self.tv_sec)
        
        let billion: TimeInterval = 1000000000.0
        
        let nanoseconds = TimeInterval(self.tv_nsec) / billion
        
        return secondsSince1970 + nanoseconds
    }
}

public extension tm {
    
    init(UTCSecondsSince1970: time_t) {
        
        var seconds = UTCSecondsSince1970
        
        // don't free!
        // The return value points to a statically allocated struct which might be overwritten by subsequent calls to any of the date and time functions.
        // http://linux.die.net/man/3/gmtime
        let timePointer = gmtime(&seconds)!
        
        self = timePointer.pointee
    }
}

// MARK: - Cross-Platform Support

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    
    public typealias POSIXMicroseconds = __darwin_suseconds_t
    
#elseif os(Linux)
    
    public typealias POSIXMicroseconds = __suseconds_t
    
    public func modf(value: Double) -> (Double, Double) {
        
        var integerValue: Double = 0
        
        let decimalValue = modf(value, &integerValue)
        
        return (decimalValue, integerValue)
    }
    
#endif
