//
//  main.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 12/16/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import XCTest

#if os(OSX) || os(iOS) || os(watchOS)
    func XCTMain(_ testCases: [XCTestCaseEntry]) { fatalError("Not Implemented. Linux only") }
    
    func testCase<T: XCTestCase>(_ allTests: [(String, (T) -> () throws -> Void)]) -> XCTestCaseEntry { fatalError("Not Implemented. Linux only") }
    
    struct XCTestCaseEntry { }
#endif

XCTMain([testCase(DateComponentsTest.allTests),
         testCase(POSIXTimeTests.allTests),
         testCase(RegularExpressionTests.allTests),
         testCase(StringTests.allTests),
         testCase(UUIDTests.allTests),
         testCase(DataTests.allTests),
         testCase(JSONTests.allTests),
         testCase(RangeTests.allTests)
    ])
