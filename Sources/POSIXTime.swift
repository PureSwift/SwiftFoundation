//
//  POSIXTime.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/19/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#elseif os(Linux)
    import Glibc
#endif

public extension timeval {
    
    static func timeOfDay() throws -> timeval {
        
        var timeStamp = timeval()
        
        guard gettimeofday(&timeStamp, nil) == 0 else {
            
            throw POSIXError.fromErrorNumber!
        }
        
        return timeStamp
    }
    
    init(timeInterval: TimeInterval) {
        
        let (integerValue, decimalValue) = modf(timeInterval)
        
        let million: TimeInterval = 1000000.0
        
        let microseconds = decimalValue * million
        
        self.init(tv_sec: Int(integerValue), tv_usec: POSIXMicroseconds(microseconds))
    }
    
    var timeIntervalValue: TimeInterval {
        
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
    
    var timeIntervalValue: TimeInterval {
        
        let secondsSince1970 = TimeInterval(self.tv_sec)
        
        let billion: TimeInterval = 1000000000.0
        
        let nanoseconds = TimeInterval(self.tv_nsec) / billion
        
        return secondsSince1970 + nanoseconds
    }
}

public extension tm {
    
    init(UTCSecondsSince1970: time_t) {
        
        var seconds = UTCSecondsSince1970
        
        let timePointer = gmtime(&seconds)
        
        self = timePointer.memory
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
