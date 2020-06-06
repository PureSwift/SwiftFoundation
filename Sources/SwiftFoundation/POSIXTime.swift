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

internal extension Date {
    
    /// Get seconds since Unix epoch (01/01/1970).
    static var timeIntervalSince1970: TimeInterval {
        
        do {
            #if arch(wasm32)
            return WebAssembly.timeIntervalSince1970()
            #else
            if #available(macOS 10.12, iOS 10, tvOS 10.0, *) {
                return try SystemClock.realTime.time().timeInterval
            } else {
                return try timeval.now().timeInterval
            }
            #endif
        }
        catch { fatalError("Unable to get current date \(error)") }
    }
}

// MARK: - WASM Fix

#if arch(wasm32)
public extension Date {
    
    public enum WebAssembly {
        
        public static var timeIntervalSince1970: () -> TimeInterval = { return try! timeval.now().timeInterval } // won't work
    }
}
#endif

// MARK: - POSIX Time

internal extension timeval {
    
    static func now() throws -> timeval {
        
        var timeStamp = timeval()
        guard gettimeofday(&timeStamp, nil) == 0
            else { throw POSIXError.fromErrno() }
        return timeStamp
    }
    
    init(timeInterval: Double) {
        
        let (integerValue, decimalValue) = modf(timeInterval)
        let million: Double = 1000000.0
        let microseconds = decimalValue * million
        self.init(tv_sec: .init(integerValue), tv_usec: .init(microseconds))
    }
    
    var timeInterval: Double {
        
        let secondsSince1970 = Double(self.tv_sec)
        let million: Double = 1000000.0
        let microseconds = Double(self.tv_usec) / million
        return secondsSince1970 + microseconds
    }
}

internal extension timespec {
    
    init(timeInterval: Double) {
        
        let (integerValue, decimalValue) = modf(timeInterval)
        let billion: Double = 1000000000.0
        let nanoseconds = decimalValue * billion
        self.init(tv_sec: .init(integerValue), tv_nsec: .init(nanoseconds))
    }
    
    var timeInterval: Double {
        
        let secondsSince1970 = Double(self.tv_sec)
        let billion: Double = 1000000000.0
        let nanoseconds = Double(self.tv_nsec) / billion
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

#if arch(wasm32)
internal struct SystemClock: RawRepresentable, Equatable, Hashable {
    let rawValue: UInt32
    init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}
#else
@available(macOS 10.12, iOS 10, tvOS 10.0, *)
internal typealias SystemClock = clockid_t
#endif

#if !arch(wasm32)
@available(macOS 10.12, iOS 10, tvOS 10.0, *)
internal extension SystemClock {
    
    
    func time() throws -> timespec {
        var time = timespec()
        guard clock_gettime(self, &time) == 0
            else { throw POSIXError.fromErrno() }
        return time
    }
    
    #if os(macOS) || os(Linux) // not supported on iOS
    func setTime(_ newValue: timespec) throws {
        guard withUnsafePointer(to: newValue, { clock_settime(self, $0) == 0 })
            else { throw POSIXError.fromErrno() }
    }
    #endif
}

#endif

#if arch(wasm32)
@_silgen_name("clock_gettime")
internal func wasm_clock_gettime() -> Int32 // crashes with current swift-wasm

/**

 Return the time value of a clock. Note: This is similar to clock_gettime in POSIX.
 
 `clock_time_get(id: clockid, precision: timestamp) -> (errno, timestamp)`
 
 - Parameter id: clockid The clock for which to return the time.
 - Parameter precision: timestamp The maximum lag (exclusive) that the returned time value may have, compared to its actual value.
- Returns: error: errno
 time: timestamp The time value of the clock.
 
 https://github.com/WebAssembly/WASI/blob/master/phases/snapshot/docs.md#-clock_time_getid-clockid-precision-timestamp---errno-timestamp
 */
@_silgen_name("clock_time_get")
internal func wasm_clock_time_get(_ id: UInt32, _ precision: UInt64, _ time: inout UInt64) -> Int16
#endif

@available(macOS 10.12, iOS 10, tvOS 10.0, *)
internal extension SystemClock {
    
    /**
     System-wide clock that measures real (i.e., wall-clock) time. Setting this clock requires appropriate privileges. This clock is affected by discontinuous jumps in the system time (e.g., if the system administrator manually changes the clock), and by the incremental adjustments performed by adjtime(3) and NTP.
     */
    static var realTime: SystemClock {
        #if arch(wasm32)
        return .init(rawValue: 0)
        #else
        return CLOCK_REALTIME
        #endif
    }
    
    /**
     Clock that cannot be set and represents monotonic time since some unspecified starting point. This clock is not affected by discontinuous jumps in the system time (e.g., if the system administrator manually changes the clock), but is affected by the incremental adjustments performed by adjtime(3) and NTP.
     */
    static var monotonic: SystemClock {
        #if arch(wasm32)
        return .init(rawValue: 1)
        #else
        return CLOCK_MONOTONIC
        #endif
    }
    
    #if os(Linux)
    /// A faster but less precise version of CLOCK_REALTIME. Use when you need very fast, but not fine-grained timestamps.
    static var realTimeCourse: SystemClock { // (since Linux 2.6.32; Linux-specific)
        return CLOCK_REALTIME_COARSE
    }
    
    /// A faster but less precise version of CLOCK_MONOTONIC. Use when you need very fast, but not fine-grained timestamps.
    static var monotonicCourse: SystemClock { // (since Linux 2.6.32; Linux-specific)
        return CLOCK_MONOTONIC_COARSE
    }
    #endif
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
