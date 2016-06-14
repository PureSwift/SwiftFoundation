//
//  POSIXTimeTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/22/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin.C
#elseif os(Linux)
    import Glibc
#endif

import XCTest
import SwiftFoundation

final class POSIXTimeTests: XCTestCase {
    
    static let allTests: [(String, (POSIXTimeTests) -> () throws -> Void)] =
        [("testGetTimeOfDay", testGetTimeOfDay),
        ("testTimeVal", testTimeVal),
        ("testTimeSpec", testTimeSpec)]
    
    func testGetTimeOfDay() {
        
        var time = timeval()
        
        do { time = try timeval.timeOfDay() }
            
        catch {
            
            XCTFail("Error getting time: \(error)")
        }
        
        print("Current time: \(time)")
    }

    func testTimeVal() {
        
        let date = SwiftFoundation.Date()
        
        let time = timeval(timeInterval: date.since1970)
        
        XCTAssert(Int(time.timeIntervalValue) == Int(date.since1970), "TimeVal derived interval: \(time.timeIntervalValue) must equal Date's timeIntervalSince1970 \(date.since1970)")
    }
    
    func testTimeSpec() {
        
        let date = SwiftFoundation.Date()
        
        let time = timespec(timeInterval: date.since1970)
        
        #if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
        
            XCTAssert(time.timeIntervalValue == date.since1970, "timespec: \(time.timeIntervalValue) == Date: \(date)")
        
        #elseif os(Linux)
            
            // do nothing for now
            
        #endif
    }

}
