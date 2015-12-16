//
//  OrderTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/3/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import XCTest
import Foundation
import SwiftFoundation

class OrderTests: XCTestCase {

    func testComparisonResult() {
        
        // number
        
        XCTAssert(1.compare(2) == Order.Ascending)
        
        XCTAssert(2.compare(1) == Order.Descending)
        
        XCTAssert(1.compare(1) == Order.Same)
        
        // string
        
        XCTAssert("a".compare("b") == Order.Ascending)
        
        XCTAssert("b".compare("a") == Order.Descending)
        
        XCTAssert("a".compare("a") == Order.Same)
        
        // dates
        
        let now = Date()
        
        let later = now + 0.5
        
        XCTAssert(now.compare(later) == Order.Ascending)
        
        XCTAssert(now < later)
    }
}

