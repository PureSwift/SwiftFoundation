//
//  StyledDateFormatterTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/24/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import XCTest
import SwiftFoundation

class StyledDateFormatterTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStringForValue() {
        
        let foundationFormatter = NSDateFormatter()
        
        foundationFormatter.dateStyle = .FullStyle
        foundationFormatter.timeStyle = .FullStyle
        
        let date = Date()
        
        let foundationString = foundationFormatter.stringFromDate(NSDate(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate))
        
        let formatter = StyledDateFormatter(dateStyle: .FullStyle, timeStyle: .FullStyle)
        
        let stringValue = formatter.stringFromValue(date)
        
        XCTAssert(foundationString == stringValue, "\(foundationString) == \(stringValue)")
    }
    
    func testMutateThreadSafety() {
        
        var dateFormatter = StyledDateFormatter(dateStyle: .FullStyle, timeStyle: .MediumStyle)
        
        let expectation = expectationWithDescription("Operation Finished")
        
        let operationQueue = NSOperationQueue()
        
        operationQueue.maxConcurrentOperationCount = 10;
        
        let numberOfThreads = 5
        
        for i in 1...numberOfThreads {
            
            var flag = true
            
            operationQueue.addOperationWithBlock({ () -> Void in
                
                // mutate
                let style: DateFormatterStyle = flag ? .FullStyle : .ShortStyle
                flag = !flag
                
                dateFormatter.dateStyle = style
                
                // format value
                _ = dateFormatter.stringFromValue(Date())
            
                if i == numberOfThreads {
                    
                    expectation.fulfill()
                }
            })
        }
        
        waitForExpectationsWithTimeout(5, handler: { error in
            XCTAssertNil(error, "Error")
        })
    }
    
    func testMethodThreadSafety() {
        
        let dateFormatter = StyledDateFormatter(dateStyle: .FullStyle, timeStyle: .MediumStyle)
        
        let expectation = expectationWithDescription("Operation Finished")
        
        let operationQueue = NSOperationQueue()
        
        operationQueue.maxConcurrentOperationCount = 10;
        
        let numberOfThreads = 5
        
        for i in 1...numberOfThreads {
            
            operationQueue.addOperationWithBlock({ () -> Void in
                
                // format value
                let string = dateFormatter.stringFromValue(Date())
                
                _ = dateFormatter.valueFromString(string)
                
                if i == numberOfThreads {
                    
                    expectation.fulfill()
                }
            })
        }
        
        waitForExpectationsWithTimeout(5, handler: { error in
            XCTAssertNil(error, "Error")
        })
    }

    func testCreationPerformance() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            
            
        }
    }

}
