//
//  POSIXTimeTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/22/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import XCTest
import SwiftFoundation

class POSIXTimeTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetTimeOfDay() {
                
        do { try timeval.timeOfDay() }
        catch {
            
            XCTFail("Error getting time: \(error)")
        }
    }

    func testTimeVal() {
        
        let date = Date()
        
        let time = timeval(timeInterval: date.timeIntervalSince1970)
        
        XCTAssert(time.timeIntervalValue == date.timeIntervalSince1970)
    }

    func testTimeSpec() {
        
        let date = Date()
        
        let time = timespec(timeInterval: date.timeIntervalSince1970)
        
        XCTAssert(time.timeIntervalValue == date.timeIntervalSince1970)
    }

}
