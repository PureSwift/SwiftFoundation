//
//  DateComponentsTest.swift
//  SwiftFoundation
//
//  Created by David Ask on 07/12/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import XCTest
import SwiftFoundation

final class DateComponentsTest: XCTestCase {
    
    static let allTests: [(String, (DateComponentsTest) -> () throws -> Void)] = [("testBuildDate", testBuildDate), ("testValueForComponent", testValueForComponent)]
    
    func testBuildDate() {
        
        var dateComponents = DateComponents()
        dateComponents.year = 1987
        dateComponents.month = 10
        dateComponents.dayOfMonth = 10
        
        let assertionDate = SwiftFoundation.Date(timeIntervalSince1970: TimeInterval(560822400))
        let madeDate = dateComponents.date
        
        print(assertionDate, madeDate)
        
        XCTAssert(assertionDate == madeDate)
    }
    
    func testValueForComponent() {
        
        let dateComponents = DateComponents(timeIntervalSince1970: 560822400)
        
        XCTAssert(dateComponents[.year] == 1987)
        XCTAssert(dateComponents[.month] == 10)
        XCTAssert(dateComponents[.dayOfMonth] == 10)
    }
}
