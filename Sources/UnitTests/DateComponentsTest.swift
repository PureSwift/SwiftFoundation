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
    
    lazy var allTests: [(String, () throws -> ())] = [("testBuildDate", self.testBuildDate)]
    
    func testBuildDate() {
        
        var dateComponents = DateComponents()
        dateComponents.year = 1987
        dateComponents.month = 10
        dateComponents.dayOfMonth = 10
        
        let assertionDate = Date(since1970: 560822400)
        let madeDate = dateComponents.date
        
        print(assertionDate, madeDate)
        
        XCTAssert(assertionDate == madeDate)
    }
}