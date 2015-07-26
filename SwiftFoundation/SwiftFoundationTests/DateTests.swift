//
//  DateTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
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
    
    func testEquality() {
        
        let date = Date()
        
        let date2 = Date(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
        
        let foundationDate = NSDate()
        
        let foundationDate2 = NSDate(timeIntervalSinceReferenceDate: foundationDate.timeIntervalSinceReferenceDate)
        
        XCTAssert(date == date2)
        
        XCTAssert(foundationDate == foundationDate2)
    }
    
    func testTimeIntervalSince1970Constant() {
        
        XCTAssert(TimeIntervalBetween1970AndReferenceDate == NSTimeIntervalSince1970, "NSTimeIntervalSince1970 == \(NSTimeIntervalSince1970)")
    }
    
    func testGetTimeIntervalSince1970() {
        
        let date = Date()
        
        let foundationDate = NSDate(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
        
        XCTAssert(date.timeIntervalSince1970 == foundationDate.timeIntervalSince1970)
    }
    
    func testCreateWithTimeIntervalSince1970() {
        
        let date = Date()
        
        XCTAssert(Date(timeIntervalSince1970: date.timeIntervalSince1970) == date, "Date should be the same as original")
    }
    
    func testSetWithTimeIntervalSince1970() {
        
        var date = Date()
        
        let foundationDate = NSDate(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
        
        date.timeIntervalSince1970 = foundationDate.timeIntervalSince1970
        
        XCTAssert(date.timeIntervalSinceReferenceDate == foundationDate.timeIntervalSinceReferenceDate)
    }
    
    /*
    func testDescription() {
        
        let date = Date()
        
        let foundationFormatter = NSDateFormatter()
        
        foundationFormatter.dateFormat = "YYYY-MM-dd hh:mm:ss";
        
        let foundationDescription = foundationFormatter.stringFromDate(NSDate(date: date))
        
        XCTAssert(date.description == foundationDescription, "\(date.description) == \(foundationDescription)")
    }
    */
    
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
