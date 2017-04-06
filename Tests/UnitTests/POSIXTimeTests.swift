//
//  POSIXTimeTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/22/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin.C
#elseif os(Linux)
    import Glibc
#endif

import XCTest
@testable import SwiftFoundation

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
        
        let time = timeval(timeInterval: date.timeIntervalSince1970)
        
        XCTAssert(Int(time.timeInterval) == Int(date.timeIntervalSince1970), "TimeVal derived interval: \(time.timeInterval) must equal Date's timeIntervalSince1970 \(date.timeIntervalSince1970)")
    }
    
    func testTimeSpec() {
        
        let date = SwiftFoundation.Date()
        
        let time = timespec(timeInterval: date.timeIntervalSince1970)
        
        #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
        
            XCTAssert(time.timeInterval == date.timeIntervalSince1970, "timespec: \(time.timeInterval) == Date: \(date)")
        
        #elseif os(Linux)
            
            // do nothing for now
            
        #endif
    }

}
