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
    
    var timeIntervalValue: TimeInterval {
        
        let secondsSince1970 = TimeInterval(self.tv_sec)
        
        let microseconds = TimeInterval(self.tv_usec) / TimeInterval(1000000.0)
        
        return secondsSince1970 + microseconds
    }
}

public extension timespec {
    
    var timeIntervalValue: TimeInterval {
        
        let secondsSince1970 = TimeInterval(self.tv_sec)
        
        let microseconds = TimeInterval(self.tv_nsec) / TimeInterval(1000000000.0)
        
        return secondsSince1970 + microseconds
    }
}