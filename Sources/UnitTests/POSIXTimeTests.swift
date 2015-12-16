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

class POSIXTimeTests: XCTestCase {
    
    func testGetTimeOfDay() {
                
        do { try timeval.timeOfDay() }
        catch {
            
            XCTFail("Error getting time: \(error)")
        }
    }

    func testTimeVal() {
        
        let date = Date()
        
        let time = timeval(timeInterval: date.timeIntervalSince1970)
        
        XCTAssert(Int(time.timeIntervalValue) == Int(date.timeIntervalSince1970), "TimeVal derived interval: \(time.timeIntervalValue) must equal Date's timeIntervalSince1970 \(date.timeIntervalSince1970)")
    }

    func testTimeSpec() {
        
        let date = Date()
        
        let time = timespec(timeInterval: date.timeIntervalSince1970)
        
        XCTAssert(time.timeIntervalValue == date.timeIntervalSince1970)
    }

}
