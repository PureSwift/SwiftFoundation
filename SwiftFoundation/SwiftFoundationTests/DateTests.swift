//
//  DateTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import XCTest
import Foundation
@testable import SwiftFoundation

class DateTests: XCTestCase {
    
    var date: Date!
    
    var foundationDate: NSDate!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let timeIntervalSinceReferenceDate = NSDate.timeIntervalSinceReferenceDate()
        
        date = Date(timeIntervalSinceReferenceDate: timeIntervalSinceReferenceDate)
        
        foundationDate = NSDate(timeIntervalSinceReferenceDate: timeIntervalSinceReferenceDate)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        date = nil
        
        foundationDate  = nil
    }
    
    // MARK: - Functional Tests
    
    func testFoundationDateEquality() {
        
        let timeIntervalSinceReferenceDate = NSDate.timeIntervalSinceReferenceDate()
        
        let date = Date(timeIntervalSinceReferenceDate: timeIntervalSinceReferenceDate)
        
        let FoundationDate = NSDate(timeIntervalSinceReferenceDate: timeIntervalSinceReferenceDate)
        
        XCTAssert(date.timeIntervalSinceReferenceDate == FoundationDate.timeIntervalSinceReferenceDate,
            "Date's internal values must be equal. (\(date.timeIntervalSinceReferenceDate) != \(FoundationDate.timeIntervalSinceReferenceDate))")
    }
    
    func testTimeIntervalSinceReferenceDateSecondsPrecision() {
        
        let interval = UInt(TimeIntervalSinceReferenceDate())
        
        let NSInterval = UInt(NSDate.timeIntervalSinceReferenceDate())
        
        XCTAssert(interval == NSInterval, "\(interval) must equal \(NSInterval)")
    }
    
    func testTimeIntervalSinceReferenceDateMicroSecondsPrecision() {
        
        let interval = TimeIntervalSinceReferenceDate()
        
        let NSInterval = NSDate.timeIntervalSinceReferenceDate()
        
        XCTAssert(interval <= NSInterval, "\(interval) must lower than or equal \(NSInterval)")
    }
    
    func testTimeIntervalSinceDate() {
        
        let time2 = NSDate.timeIntervalSinceReferenceDate()
        
        let date2 = Date(timeIntervalSinceReferenceDate: time2)
        
        let foundationDate2 = NSDate(timeIntervalSinceReferenceDate: time2)
        
        let intervalSinceDate = date.timeIntervalSinceDate(date2)
        
        let foundationIntervalSinceDate = foundationDate.timeIntervalSinceDate(foundationDate2)
        
        XCTAssert(intervalSinceDate == foundationIntervalSinceDate)
    }
    
    // MARK: - Performance Tests
    
    func testCreationPerformance() {
        
        self.measureBlock() {
            
            for _ in 0...1000000 {
                
                _ = Date.init()
            }
        }
    }
    
    func testFoundationCreationPerformance() {
        
        self.measureBlock() {
            
            for _ in 0...1000000 {
                
                _ = NSDate.init()
            }
        }
    }
}
