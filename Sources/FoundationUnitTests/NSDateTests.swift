//
//  DateTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)

import XCTest
import Foundation
import SwiftFoundation

final class DateTests: XCTestCase {
    
    var date: SwiftFoundation.Date!
    
    var foundationDate: NSDate!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let timeIntervalSinceReferenceDate = NSDate.timeIntervalSinceReferenceDate()
        
        date = Date(sinceReferenceDate: timeIntervalSinceReferenceDate)
        
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
        
        let date = Date(sinceReferenceDate: timeIntervalSinceReferenceDate)
        
        let FoundationDate = NSDate(timeIntervalSinceReferenceDate: timeIntervalSinceReferenceDate)
        
        XCTAssert(date.sinceReferenceDate == FoundationDate.timeIntervalSinceReferenceDate,
            "Date's internal values must be equal. (\(date.sinceReferenceDate) != \(FoundationDate.timeIntervalSinceReferenceDate))")
    }
    
    func testTimeIntervalSinceReferenceDateSecondsPrecision() {
        
        let interval = UInt(TimeIntervalSinceReferenceDate())
        
        let NSInterval = UInt(NSDate.timeIntervalSinceReferenceDate())
        
        XCTAssert(interval == NSInterval, "\(interval) must equal \(NSInterval)")
    }
    
    /*
    func testTimeIntervalSinceReferenceDateMicroSecondsPrecision() {
        
        let interval = TimeIntervalSinceReferenceDate()
        
        let NSInterval = NSDate.timeIntervalSinceReferenceDate()
        
        XCTAssert(interval <= NSInterval, "\(interval) must lower than or equal \(NSInterval)")
    }
    */
    
    func testTimeIntervalSinceDate() {
        
        let time2 = NSDate.timeIntervalSinceReferenceDate()
        
        let date2 = Date(sinceReferenceDate: time2)
        
        let foundationDate2 = NSDate(timeIntervalSinceReferenceDate: time2)
        
        let intervalSinceDate = date.timeIntervalSince(date: date2)
        
        let foundationIntervalSinceDate = foundationDate.timeIntervalSince(foundationDate2 as Foundation.Date)
        
        XCTAssert(intervalSinceDate == foundationIntervalSinceDate)
    }
    
    func testEquality() {
        
        let date = SwiftFoundation.Date()
        
        let date2 = Date(sinceReferenceDate: date.sinceReferenceDate)
        
        let foundationDate = NSDate()
        
        let foundationDate2 = NSDate(timeIntervalSinceReferenceDate: foundationDate.timeIntervalSinceReferenceDate)
        
        XCTAssert(date == date2)
        
        XCTAssert(foundationDate == foundationDate2)
    }
    
    func testTimeIntervalSince1970Constant() {
        
        XCTAssert(TimeIntervalBetween1970AndReferenceDate == NSTimeIntervalSince1970, "NSTimeIntervalSince1970 == \(NSTimeIntervalSince1970)")
    }
    
    func testGetTimeIntervalSince1970() {
        
        let date = SwiftFoundation.Date()
        
        let foundationDate = NSDate(timeIntervalSinceReferenceDate: date.sinceReferenceDate)
        
        XCTAssert(date.since1970 == foundationDate.timeIntervalSince1970)
    }
    
    func testCreateWithTimeIntervalSince1970() {
        
        let date = SwiftFoundation.Date()
        
        XCTAssert(Date(since1970: date.since1970) == date, "Date should be the same as original")
    }
    
    func testSetWithTimeIntervalSince1970() {
        
        var date = SwiftFoundation.Date()
        
        let foundationDate = NSDate(timeIntervalSinceReferenceDate: date.sinceReferenceDate)
        
        date.since1970 = foundationDate.timeIntervalSince1970
        
        XCTAssert(date.sinceReferenceDate == foundationDate.timeIntervalSinceReferenceDate)
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
        
        self.measure {
            
            for _ in 0...1000000 {
                
                _ = SwiftFoundation.Date.init()
            }
        }
    }
    
    func testFoundationCreationPerformance() {
        
        self.measure {
            
            for _ in 0...1000000 {
                
                _ = Foundation.Date()
            }
        }
    }
}

#endif
