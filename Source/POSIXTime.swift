//
//  POSIXTime.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/19/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

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
        
        typealias Microseconds = __darwin_suseconds_t
        
        self.init(tv_sec: Int(integerValue), tv_usec: Microseconds(microseconds))
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