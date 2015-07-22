//: Playground - noun: a place where people can play

import SwiftFoundation
import Foundation

public extension timeval {
    
    static func timeOfDay() throws -> timeval {
        
        var timeStamp = timeval()
        
        guard gettimeofday(&timeStamp, nil) == 0 else {
            
            throw POSIXError.fromErrorNumber!
        }
        
        return timeStamp
    }
    
    init(timeInterval: TimeInterval) {
        
        typealias Microseconds = __darwin_suseconds_t
        
        timeInterval
        
        let (integerValue, decimalValue) = modf(timeInterval)
        
        let million: TimeInterval = 1000000.0
        
        decimalValue
        
        let microseconds = decimalValue * million
        
        self.init(tv_sec: Int(integerValue), tv_usec: Microseconds(microseconds))
    }
    
    var timeIntervalValue: TimeInterval {
        
        let secondsSince1970 = TimeInterval(self.tv_sec)
        
        let million: TimeInterval = 1000000.0
        
        let microseconds = TimeInterval(self.tv_usec) / million
        
        return secondsSince1970 + microseconds
    }
}

let date = Date()

date.timeIntervalSince1970

let time = timeval(timeInterval: date.timeIntervalSince1970)

time.tv_sec

time.tv_usec

date.timeIntervalSince1970

let (integerValue, decimalValue) = modf(date.timeIntervalSince1970)

integerValue

decimalValue

time.timeIntervalValue == date.timeIntervalSince1970
