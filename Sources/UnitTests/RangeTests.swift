//
//  RangeTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 3/31/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import XCTest
import SwiftFoundation

final class RangeTests: XCTestCase {
    
    lazy var allTests: [(String, () throws -> ())] = [ ("testSubset", self.testSubset) ]

    func testSubset() {
        
        let superset = 1 ... 10
        
        XCTAssert((1...10).isSubset(superset))
        XCTAssert((1...9).isSubset(superset))
        XCTAssert((2...10).isSubset(superset))
        XCTAssert((2...9).isSubset(superset))
        
        XCTAssert((0...10).isSubset(superset) == false)
        XCTAssert((0...11).isSubset(superset) == false)
    }
}
