//
//  OrderTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/3/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import XCTest
import SwiftFoundation

final class OrderTests: XCTestCase {
    
    static let allTests: [(String, OrderTests -> () throws -> Void)] = [("testComparisonResult", testComparisonResult)]

    func testComparisonResult() {
        
        // number
        
        XCTAssert((1 as Int).compare(2) == .ascending)
        
        XCTAssert((2 as Int).compare(1) == .descending)
        
        XCTAssert((1 as Int).compare(1) == .same)
        
        // string
        
        XCTAssert("a".compare("b") == .ascending)
        
        XCTAssert("b".compare("a") == .descending)
        
        XCTAssert("a".compare("a") == .same)
        
        // dates
        
        let now = Date()
        
        let later = now + 0.5
        
        XCTAssert(now.compare(later) == .ascending)
        
        XCTAssert(now < later)
    }
}

