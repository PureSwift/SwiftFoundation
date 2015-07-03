//
//  OrderTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/3/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import XCTest
import Foundation
import SwiftFoundation

class OrderTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testComparisonResult() {
        
        // number
        
        XCTAssert(1.compare(2) == 1.compare(NSNumber(integer: 2)).toOrder())
        
        XCTAssert(2.compare(1) == 2.compare(NSNumber(integer: 1)).toOrder())
        
        XCTAssert(1.compare(1) == 1.compare(NSNumber(integer: 1)).toOrder())
        
        // string
        
        XCTAssert("a".compare("b") == ("a" as NSString).compare("b" as String).toOrder())
        
        XCTAssert("b".compare("a") == ("b" as NSString).compare("a" as String).toOrder())
        
        XCTAssert("a".compare("a") == ("a" as NSString).compare("a" as String).toOrder())
        
        // dates
        
        let now = Date()
        
        let later = now + 0.5
        
        let foundationNow = NSDate()
        
        let foundationLater = foundationNow.dateByAddingTimeInterval(0.5)
        
        XCTAssert(now.compare(later) == foundationNow.compare(foundationLater).toOrder())
        
        XCTAssert(now < later)
    }
}

extension NSComparisonResult {
    
    func toOrder() -> Order {
        
        switch self {
            
        case .OrderedAscending: return .Ascending
        case .OrderedDescending: return .Descending
        case .OrderedSame: return .Same
        }
    }
}