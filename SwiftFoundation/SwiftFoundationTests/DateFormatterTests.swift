//
//  DateFormatterTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/25/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import XCTest
import SwiftFoundation

class DateFormatterTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStringFromDate() {
        
        let date = Date()
        
        let formatString = "YYYY-MM-dd hh:mm:ss"
        
        let foundationDate = NSDate(date: date)
        
        let formatter = DateFormatter(format: formatString, properties: [], locale: nil)
        
        let foundationFormatter = NSDateFormatter()
        
        foundationFormatter.dateFormat = formatString;
        
        let stringValue = formatter.stringFromValue(date)
        
        let foundationStringValue = foundationFormatter.stringFromDate(foundationDate)
        
        XCTAssert(stringValue == foundationStringValue, "\(stringValue) == \(foundationStringValue)")
    }
    
    func testDateFromString() {

        let formatString = "YYYY-MM-dd hh:mm:ss"
        
        let formatter = DateFormatter(format: formatString, properties: [], locale: nil)
        
        let foundationFormatter = NSDateFormatter()
        
        foundationFormatter.dateFormat = formatString;
        
        let foundationStringValue = foundationFormatter.stringFromDate(NSDate())
        
        let foundationDate = foundationFormatter.dateFromString(foundationStringValue)!
        
        guard let date = formatter.valueFromString(foundationStringValue) else {
            
            XCTFail("Could not create date from string")
            
            return
        }
        
        XCTAssert(date.timeIntervalSinceReferenceDate == foundationDate.timeIntervalSinceReferenceDate, "\(date.timeIntervalSinceReferenceDate) == \(foundationDate.timeIntervalSinceReferenceDate)")
    }

}


