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
    
    static let allTests: [(String, (RangeTests) -> () throws -> Void)] = [ ("testSubset", testSubset) ]

    func testSubset() {
        
        let superset = Range(1 ... 10)
        
        XCTAssert(Range(1...10).isSubset(superset))
        XCTAssert(Range(1...9).isSubset(superset))
        XCTAssert(Range(2...10).isSubset(superset))
        XCTAssert(Range(2...9).isSubset(superset))
        
        XCTAssert((Range(0...10).isSubset(superset)) == false)
        XCTAssert((Range(0...11).isSubset(superset)) == false)
        
        
    }
    
    func testSubsetContainsElement() {
        
        let superset = Range(1 ... 10)
        
        XCTAssert(Range(1...10).verifyElements(of: superset))
        XCTAssert(Range(1...9).verifyElements(of: superset))
        XCTAssert(Range(2...10).verifyElements(of: superset))
        XCTAssert(Range(2...9).verifyElements(of: superset))
        
        XCTAssert((Range(0...10).verifyElements(of: superset)) == false)
        XCTAssert((Range(0...11).verifyElements(of: superset)) == false)
    }
}

private extension Range where Bound: Integer {
    
    func verifyElements(of superset: Range<Int>) -> Bool {
        
        /// dont try this at home kids
        let range = unsafeBitCast(self, to: Range<Int>.self)
        
        for element in range.lowerBound ..< range.upperBound {
            
            guard superset.contains(element)
                else { return false }
        }
        
        return true
    }
}